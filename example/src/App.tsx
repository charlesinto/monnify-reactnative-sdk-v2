import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { multiply } from 'react-native-monnify-react-native-v2';

// RNMonnifySDK.initialize({
//   apiKey: 'MK_PROD_AB4CTHQZYQ',
//   contractCode: '915483727513',
// });

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  // const chargeCarge = () => {
  //   RNMonnifySDK.initializePayment({
  //     amount: 1200.5,
  //     customerName: 'Tobi Adeyemi',
  //     customerEmail: 'tobiadeyemi@gmail.com',
  //     paymentReference: '222',
  //     paymentDescription: 'Foodies',
  //     currencyCode: 'NGN',
  //     incomeSplitConfig: [],
  //   })
  //     .then((response: any) => {
  //       console.log(response); // card charged successfully, get reference here
  //     })
  //     .catch((error: any) => {
  //       console.log(error); // error is a javascript Error object
  //       console.log(error.message);
  //       console.log(error.code);
  //     });
  // };

  React.useEffect(() => {
    // console.log('> RNMonnify: ', RNMonnifySDK);
    multiply(9, 10).then(setResult);
  }, []);

  return (
    <View style={styles.container}>
      <Text>{result}</Text>
      {/* <Button title="Press me" onPress={chargeCarge} /> */}
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
