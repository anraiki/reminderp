import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'convex_client_service.dart';
import 'sync_runtime_service.dart';

class AuthService {
  static const _tokenKey = 'convex_auth_token';
  static const _refreshTokenKey = 'convex_auth_refresh_token';
  static const _oauthVerifierKey = 'convex_auth_oauth_verifier';
  static bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final client = await ConvexClientService.getClient();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      await client.setAuth(token: token);
      await SyncRuntimeService.instance.enableSync();
      return;
    }

    final refreshToken = prefs.getString(_refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) return;

    final result = await _callSignIn(args: {'refreshToken': refreshToken});
    await _persistTokens(result);
  }

  Future<String?> completeWebOAuthIfNeeded() async {
    if (!kIsWeb) return null;
    final code = Uri.base.queryParameters['code'];
    if (code == null || code.isEmpty) return null;

    final prefs = await SharedPreferences.getInstance();
    final verifier = prefs.getString(_oauthVerifierKey);

    final result = await _callSignIn(
      args: {
        'params': {'code': code},
        if (verifier != null && verifier.isNotEmpty) 'verifier': verifier,
      },
    );
    await prefs.remove(_oauthVerifierKey);
    final token = await _persistTokens(result);
    return token == null ? null : 'Signed in with Google';
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required bool createAccount,
  }) async {
    final result = await _callSignIn(
      args: {
        'provider': 'password',
        'params': {
          'flow': createAccount ? 'signUp' : 'signIn',
          'email': email,
          'password': password,
        },
      },
    );
    final token = await _persistTokens(result);
    if (token == null) {
      throw StateError('Sign in failed. Check your email/password.');
    }
  }

  Future<void> signInWithGoogle() async {
    if (!kIsWeb) {
      throw StateError(
        'Google sign-in is currently enabled for web builds. Use email on mobile/desktop.',
      );
    }

    final result = await _callSignIn(
      args: {
        'provider': 'google',
        'params': {'redirectTo': '/'},
      },
    );

    final redirect = result['redirect'] as String?;
    if (redirect == null || redirect.isEmpty) {
      throw StateError('Google sign-in did not return a redirect URL.');
    }

    final verifier = result['verifier'] as String?;
    if (verifier != null && verifier.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_oauthVerifierKey, verifier);
    }

    final launched = await launchUrl(
      Uri.parse(redirect),
      webOnlyWindowName: '_self',
    );
    if (!launched) {
      throw StateError('Could not open Google sign-in page.');
    }
  }

  Future<void> signOut() async {
    final client = await ConvexClientService.getClient();
    await client.setAuth(token: null);
    SyncRuntimeService.instance.disableSync();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_oauthVerifierKey);
  }

  Future<Map<String, dynamic>> _callSignIn({
    required Map<String, dynamic> args,
  }) async {
    final client = await ConvexClientService.getClient();
    final raw = await client.action(name: 'auth:signIn', args: args);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Unexpected auth response: $decoded');
    }
    return decoded;
  }

  Future<String?> _persistTokens(Map<String, dynamic> payload) async {
    final tokens = payload['tokens'];
    if (tokens is! Map<String, dynamic>) return null;

    final token = tokens['token'] as String?;
    final refreshToken = tokens['refreshToken'] as String?;
    if (token == null || token.isEmpty) return null;

    final client = await ConvexClientService.getClient();
    await client.setAuth(token: token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
    await SyncRuntimeService.instance.enableSync();
    return token;
  }
}
