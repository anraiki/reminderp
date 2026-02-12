import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  RevenueCatService._();

  static const String _iosApiKey = 'test_nwedLdFzLCJgnanEXBmvVoIQprZ';
  static const String _androidApiKey = 'test_nwedLdFzLCJgnanEXBmvVoIQprZ';

  static Future<void> initialize() async {
    if (kIsWeb) return;

    final String apiKey;
    if (Platform.isIOS) {
      apiKey = _iosApiKey;
    } else if (Platform.isAndroid) {
      apiKey = _androidApiKey;
    } else {
      return;
    }

    await Purchases.configure(PurchasesConfiguration(apiKey));
  }
}
