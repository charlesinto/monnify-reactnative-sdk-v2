import * as React from 'react';

import { StyleSheet, View, Button, Text } from 'react-native';
import { multiply, RNMonnifySDK } from 'react-native-monnify-react-native-v2';

RNMonnifySDK.initialize({
  apiKey: 'MK_PROD_2H9QAEL6S9',
  contractCode: '736278528428',
  applicationMode: 'LIVE',
});

console.log('rnmon> ', RNMonnifySDK);

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  const chargeCarge = () => {
    RNMonnifySDK.initializePayment({
      amount: 1200.5,
      customerName: 'Tobi Adeyemi',
      customerEmail: 'tobiadeyemi@gmail.com',
      paymentReference: `${new Date().getTime()}`,
      paymentDescription: 'Foodies',
      currencyCode: 'NGN',
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
  };

  React.useEffect(() => {
    multiply(20, 10).then(setResult);
  }, []);

  return (
    <View style={styles.container}>
      <Text>{result}</Text>
      <Button title="Pay Now" onPress={chargeCarge} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
