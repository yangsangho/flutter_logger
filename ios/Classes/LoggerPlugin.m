#import "LoggerPlugin.h"
#if __has_include(<logger/logger-Swift.h>)
#import <logger/logger-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "logger-Swift.h"
#endif

@implementation LoggerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLoggerPlugin registerWithRegistrar:registrar];
}
@end
