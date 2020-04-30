#import "FlutterApplinksPlugin.h"
#import <UserNotifications/UserNotifications.h>
#if __has_include(<flutter_applinks/flutter_applinks-Swift.h>)
#import <flutter_applinks/flutter_applinks-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_applinks-Swift.h"
#endif

@implementation FlutterApplinksPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
          methodChannelWithName:@"flutter_applinks"
                binaryMessenger:[registrar messenger]];
    FlutterApplinksPlugin * instance = [[FlutterApplinksPlugin alloc] init];
        instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);

}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {

    NSString * url = userActivity.webpageURL.absoluteString;
    [self.channel invokeMethod:@"openApplinks" arguments:@{@"url": url}];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    NSString * token = [self getHexStringForData:deviceToken];
    if(token != nil && token.length > 0){
        [channel invokeMethod:"app_push_token" arguments:token];
    }
}


- (NSString *)getHexStringForData:(NSData *)data
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {

        if (![data isKindOfClass:[NSData class]]) {
            return @"";
        }
        NSUInteger len = [data length];
        char *chars = (char *)[data bytes];
        NSMutableString *hexString = [[NSMutableString alloc]init];
        for (NSUInteger i=0; i<len; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx" , chars[i]]];
        }
        return hexString;
    } else {
         NSString *myToken = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        return myToken;
    }
}

@end
