import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> FlutterApplinksHandler(String url);
typedef Future<dynamic> FlutterAppPushTokenHandler(String token);

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


  static Future<String?> addEventHandler({
    FlutterApplinksHandler? openApplinks,
    FlutterAppPushTokenHandler? pushToken,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (Link == call.method) {
        String? url = call.arguments["url"];
        if (url != null && url.length > 0) {
          return await openApplinks?.call(url);
        }
      } else if (Token == call.method) {
        String? token = call.arguments;
        if (token != null && token.length > 0) {
          return await pushToken?.call(token);
        }
      }
      return null;
    });
  }
}
