#import <Flutter/Flutter.h>

@interface FlutterApplinksPlugin : NSObject<FlutterPlugin>

@property FlutterMethodChannel *channel;

@property (copy, nonatomic) NSString * appLink;

@end
