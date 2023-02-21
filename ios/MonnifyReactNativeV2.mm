#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(RNMonnifyModule, NSObject)
RCT_EXTERN_METHOD(initialize :(NSDictionary *)options)
RCT_EXTERN_METHOD(initializePayment :(NSDictionary *)options :(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
@end
