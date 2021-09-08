import 'dart:async';

import 'package:flutter/services.dart';

typedef void FlutterApplinksHandler(String value);

class FlutterApplinks {
  static const MethodChannel _channel = const MethodChannel('flutter_applinks');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get appLinks async {
    final String? appLinks = await _channel.invokeMethod('appLinks');
    return appLinks;
  }

  static const Link = "openApplinks";
  static const Token = "app_push_token";

  static void addEventHandler({
    FlutterApplinksHandler? openApplinks,
    FlutterApplinksHandler? pushToken,
  }) async {
    _channel.setMethodCallHandler(
      (call) async {
        if (Link == call.method) {
          String? url = call.arguments;
          if (url != null && url.length > 0) {
            openApplinks?.call(url);
          }
        } else if (Token == call.method) {
          String? token = call.arguments;
          if (token != null && token.length > 0) {
            pushToken?.call(token);
          }
        }
      },
    );
  }
}
