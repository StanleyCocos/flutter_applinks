import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> FlutterApplinksHandler(String url);
typedef Future<dynamic> FlutterAppPushTokenHandler(String token);

class FlutterApplinks {
  static const MethodChannel _channel = const MethodChannel('flutter_applinks');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> addEventHandler({
    FlutterApplinksHandler openApplinks,
    FlutterAppPushTokenHandler pushToken,
  }) async {
    _channel.setMethodCallHandler((call){
      if("openApplinks" == call.method){
        String url = call.arguments["url"];
        if(url != null && url.length > 0){
          return openApplinks(url);
        }
      } else if("app_push_token" == call.method){
        String token = call.arguments;
        if(token != null && token.length > 0){
          return pushToken(token);
        }
      }
      return null;
    });
  }
}
