import 'package:convex_flutter/convex_flutter.dart';

class ConvexClientService {
  static ConvexClient? _client;
  static const String _defaultDevUrl = 'https://glad-crow-591.convex.cloud';
  static const String _defaultProdUrl =
      'https://hushed-setter-787.convex.cloud';

  static Future<ConvexClient> getClient() async {
    if (_client != null) return _client!;

    const explicitUrl = String.fromEnvironment('CONVEX_URL');
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    const devUrl = String.fromEnvironment('CONVEX_URL_DEV');
    const prodUrl = String.fromEnvironment('CONVEX_URL_PROD');
    final resolvedDevUrl = devUrl.isNotEmpty ? devUrl : _defaultDevUrl;
    final resolvedProdUrl = prodUrl.isNotEmpty ? prodUrl : _defaultProdUrl;
    final deploymentUrl = explicitUrl.isNotEmpty
        ? explicitUrl
        : (appEnv == 'prod' ? resolvedProdUrl : resolvedDevUrl);

    if (deploymentUrl.isEmpty) {
      throw StateError(
        'Missing Convex URL. Provide either CONVEX_URL, or APP_ENV + CONVEX_URL_DEV/CONVEX_URL_PROD.',
      );
    }

    await ConvexClient.initialize(
      ConvexConfig(deploymentUrl: deploymentUrl, clientId: 'reminderp-flutter'),
    );
    _client = ConvexClient.instance;
    return _client!;
  }
}
