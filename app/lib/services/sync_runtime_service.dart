import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'convex_client_service.dart';
import 'db_service.dart';
import 'sync_service.dart';

class SyncRuntimeService {
  SyncRuntimeService._();

  static final SyncRuntimeService instance = SyncRuntimeService._();
  static const _tokenKey = 'convex_auth_token';
  static const Duration _syncInterval = Duration(seconds: 20);

  SyncService? _syncService;
  Timer? _timer;
  bool _initialized = false;

  Future<void> initialize({required DbService db}) async {
    if (_initialized) return;
    _initialized = true;

    try {
      final convex = await ConvexClientService.getClient();
      _syncService = SyncService(convex: convex, db: db);
    } catch (e) {
      debugPrint('SYNC: Convex unavailable during init: $e');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      await enableSync();
    }
  }

  Future<void> enableSync() async {
    if (_syncService == null) return;
    _syncService!.enable();
    await syncNow();
    _startPeriodicSync();
  }

  Future<void> syncNow() async {
    if (_syncService == null || !_syncService!.isEnabled) return;
    try {
      await _syncService!.syncAll();
    } catch (e) {
      debugPrint('SYNC: syncNow failed: $e');
    }
  }

  void disableSync() {
    _timer?.cancel();
    _timer = null;
    _syncService?.disable();
  }

  void _startPeriodicSync() {
    _timer?.cancel();
    _timer = Timer.periodic(_syncInterval, (_) {
      unawaited(syncNow());
    });
  }
}
