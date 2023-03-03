#import "MonnifyReactNativeV2.h"
#import "MonnifyReactNativeV2-Bridging-Header.h"
#import <React/RCTLog.h>


@implementation MonnifyReactNativeV2
RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(double)a withB:(double)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(5 * 10);

    resolve(result);
}

RCT_EXPORT_METHOD(initialize :(NSDictionary *)options){}

RCT_EXPORT_METHOD(initializePayment :(NSDictionary *)options :(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){}


// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeMonnifyReactNativeV2SpecJSI>(params);
}
#endif

@end
