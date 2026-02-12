import 'package:convex_flutter/convex_flutter.dart';

class ConvexClientService {
  static ConvexClient? _client;

  static Future<ConvexClient> getClient() async {
    if (_client != null) return _client!;

    final deploymentUrl = const String.fromEnvironment('CONVEX_URL');
    if (deploymentUrl.isEmpty) {
      throw StateError(
        'Missing CONVEX_URL. Start app with --dart-define=CONVEX_URL=https://<deployment>.convex.cloud',
      );
    }

    await ConvexClient.initialize(
      ConvexConfig(deploymentUrl: deploymentUrl, clientId: 'reminderp-flutter'),
    );
    _client = ConvexClient.instance;
    return _client!;
  }
}
