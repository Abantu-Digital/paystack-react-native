#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PaystackReactNative, NSObject)

RCT_EXTERN_METHOD(initSdk:(String)publicKey)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
