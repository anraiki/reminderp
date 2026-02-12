import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

class CryptoService {
  static const _keyStorageKey = 'reminderp_sync_key';
  static const _saltStorageKey = 'reminderp_sync_salt';
  static const _pbkdf2Iterations = 100000;
  static const _keyLength = 32; // 256 bits

  final FlutterSecureStorage _secureStorage;

  Uint8List? _derivedKey;

  CryptoService({FlutterSecureStorage? secureStorage})
      : _secureStorage =
            secureStorage ?? const FlutterSecureStorage();

  bool get hasKey => _derivedKey != null;

  /// Derive a 256-bit key from a passphrase using PBKDF2 and store it securely.
  Future<void> deriveAndStoreKey(String passphrase) async {
    final salt = _generateSecureRandom(16);
    final key = _deriveKey(passphrase, salt);

    await _secureStorage.write(
      key: _keyStorageKey,
      value: base64Encode(key),
    );
    await _secureStorage.write(
      key: _saltStorageKey,
      value: base64Encode(salt),
    );

    _derivedKey = key;
  }

  /// Load the previously stored key into memory.
  Future<bool> loadKey() async {
    final storedKey = await _secureStorage.read(key: _keyStorageKey);
    if (storedKey == null) return false;
    _derivedKey = base64Decode(storedKey);
    return true;
  }

  /// Encrypt plaintext JSON string. Returns a map with `ciphertext` and `iv` (both base64).
  Map<String, String> encryptData(String plaintext) {
    _ensureKey();
    final iv = encrypt.IV.fromSecureRandom(12); // 96-bit IV for GCM
    final key = encrypt.Key(_derivedKey!);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.gcm),
    );
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    return {
      'ciphertext': encrypted.base64,
      'iv': iv.base64,
    };
  }

  /// Decrypt ciphertext using the stored key.
  String decryptData(String ciphertextBase64, String ivBase64) {
    _ensureKey();
    final iv = encrypt.IV.fromBase64(ivBase64);
    final key = encrypt.Key(_derivedKey!);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.gcm),
    );
    return encrypter.decrypt64(ciphertextBase64, iv: iv);
  }

  /// Remove stored key material.
  Future<void> clearKey() async {
    _derivedKey = null;
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _saltStorageKey);
  }

  Uint8List _deriveKey(String passphrase, Uint8List salt) {
    final derivator = PBKDF2KeyDerivator(
      HMac(SHA256Digest(), 64),
    )..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));
    return derivator.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  Uint8List _generateSecureRandom(int length) {
    final random = FortunaRandom();
    final seed = Uint8List(32);
    // Use dart:math to seed Fortuna
    final dartRandom = DateTime.now().microsecondsSinceEpoch;
    for (var i = 0; i < seed.length; i++) {
      seed[i] = (dartRandom + i) % 256;
    }
    random.seed(KeyParameter(seed));
    return random.nextBytes(length);
  }

  void _ensureKey() {
    if (_derivedKey == null) {
      throw StateError(
        'No encryption key loaded. Call deriveAndStoreKey() or loadKey() first.',
      );
    }
  }
}
