import { NativeModules, Platform } from 'react-native';
import type { IPaymentParams } from './interfaces';

const LINKING_ERROR =
  `The package 'paystack-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const PaystackReactNative = NativeModules.PaystackReactNative
  ? NativeModules.PaystackReactNative
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function chargeCard(paymentParams: IPaymentParams): Promise<string> {
  return PaystackReactNative.chargeCard(paymentParams);
}
export function init(publicKey: string): void {
  return PaystackReactNative.initSdk(publicKey);
}
