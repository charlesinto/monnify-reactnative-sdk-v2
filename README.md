# monnify-react-native-v2

monnify react native sdk

## Installation

```sh
npm i monnify-react-native-v2
```

## Usage

```js
import { RNMonnifySDK } from 'monnify-react-native-v2';

// ...
RNMonnifySDK.initialize({
  apiKey: 'XXXXXXXX',
  contractCode: 'XXXXXXXXX',
  applicationMode: 'LIVE' || 'TEST',
});

RNMonnifySDK.initializePayment({
  amount: 1200.5,
  customerName: 'XXXXXXXXXX',
  customerEmail: 'XXXXXXXXXX',
  paymentReference: 'XXXXXXXX',
  paymentDescription: 'XXXXXXXX',
  currencyCode: 'XXXXXXX',
  incomeSplitConfig: [],
})
  .then((response: any) => {
    console.log(response); // card charged successfully, get reference here
  })
  .catch((error: any) => {
    console.log(error); // error is a javascript Error object
    console.log(error.message);
    console.log(error.code);
  });
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
