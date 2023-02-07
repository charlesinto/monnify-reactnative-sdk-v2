import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-monnify-react-native-v2' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const MonnifyReactNativeV2 = NativeModules.MonnifyReactNativeV2
  ? NativeModules.MonnifyReactNativeV2
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return MonnifyReactNativeV2.multiply(a, b);
}

const checkInit = (instance: any) => {
  if (!instance.monnifyInitialized) {
    throw new Error('Please call initialize method first');
  }
};

class RNMonnify {
  monnifyInitialized = false;

  initialize(options: any) {
    if (typeof options !== 'object') {
      return Promise.reject(
        new Error('Method argument can only be a Javascript object')
      );
    }

    this.monnifyInitialized = true;

    return MonnifyReactNativeV2.initialize(options);
  }

  initializePayment(paymentParams: any) {
    if (typeof paymentParams !== 'object') {
      return Promise.reject(
        new Error('Method argument can only be a Javascript object')
      );
    }

    checkInit(this);

    console.log('payment params> ', paymentParams);

    return MonnifyReactNativeV2.initializePayment(paymentParams);
  }
}

export const RNMonnifySDK = new RNMonnify();

// export function RNMonnify() {
//   let monnifyInitialized = false;

//   return {
//     initialize: (options: any) => {
//       if (typeof options !== 'object') {
//         return Promise.reject(
//           new Error('Method argument can only be a Javascript object')
//         );
//       }

//       this.monnifyInitialized = true;

//       return MonnifyReactNativeV2.initialize(options);
//     },

//     initializePayment(paymentParams: any) {
//       if (typeof paymentParams !== 'object') {
//         return Promise.reject(
//           new Error('Method argument can only be a Javascript object')
//         );
//       }

//       checkInit(this);

//       return MonnifyReactNativeV2.initializePayment(paymentParams);
//     },
//   };
// };
