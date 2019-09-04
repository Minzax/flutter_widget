#import "FlutterWidgetPlugin.h"
#import <flutter_widget/flutter_widget-Swift.h>

@implementation FlutterWidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWidgetPlugin registerWithRegistrar:registrar];
}
@end
