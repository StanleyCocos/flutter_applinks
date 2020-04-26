import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> FlutterApplinksHandler(String url);

class FlutterApplinks {
  static const MethodChannel _channel = const MethodChannel('flutter_applinks');

  static Future<String> get appLinks async {
    final String appLinks = await _channel.invokeMethod('appLinks');
    return appLinks;
  }

  static Future<dynamic> addEventHandler({
    FlutterApplinksHandler openApplinks,
  }) async {
    _channel.setMethodCallHandler((call) {
      if ("openApplinks" == call.method) {
        String url = call.arguments["url"];
        if (url != null && url.length > 0) {
          return openApplinks(url);
        }
      }
      return null;
    });
  }
}
