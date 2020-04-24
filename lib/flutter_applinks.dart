import 'dart:async';

import 'package:flutter/services.dart';

typedef Future<dynamic> FlutterApplinksHandler(String url);

class FlutterApplinks {
  static const MethodChannel _channel = const MethodChannel('flutter_applinks');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> addEventHandler({
    FlutterApplinksHandler openApplinks,
  }) async {
    _channel.setMethodCallHandler((call){
      if("openApplinks" == call.method){
        String url = call.arguments["url"];
        if(url != null && url.length > 0){
          return openApplinks(url);
        }
      }
      return null;
    });
  }


//  static Future<Null> _handleMethod(MethodCall call) async {
//
//    if("openApplinks" == call.method){
//      String url = call.arguments["url"];
//      if(url != null && url.length > 0){
//        return openApplinks(url);
//      }
//
//    }
//    throw new UnsupportedError("Unrecognized Event");
//  }

}
