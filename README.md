# paystack-react-native

A React Native wrapper for the Paystack iOS and Android SDK's

## Installation

```sh
npm install paystack-react-native
```

```sh
yarn add paystack-react-native
```

## IOS

```sh
  pod install
```

## Usage

The paystack-react-native module exports two methods: initSdk and chargeCard.

`initSdk(publicKey: string): void`

This method initializes the Paystack SDK with your public key. You should call this method once in your app, preferably at the entry point.

### Example

```js
import Paystack from 'paystack-react-native';

const publicKey = 'YOUR_PAYSTACK_PUBLIC_KEY';

Paystack.initSdk(publicKey);
```

`chargeCard(paymentParams: IPaymentParams): void`

This method charges a card using the provided payment parameters.

### Parameters

`paymentParams (required): an object containing the payment parameters. The payment parameters should have the following type:`

```ts
interface IPaymentParams {
  cardNumber: string;
  expiryMonth: string;
  expiryYear: string;
  cvc: string;
  email: string;
  amount: number;
  currency: string;
  subAccount: string;
  transactionCharge: number; // How much commission are you charging
  bearer: string; // who is paying for fees 'account' || 'subaccount'
  reference: string;
}
```

### Example

```js
import Paystack from 'paystack-react-native';

const paymentParams = {
  cardNumber: '4084084084084081',
  expiryMonth: '01',
  expiryYear: '23',
  cvc: '408',
  email: 'test@example.com',
  amount: 100000,
  currency: 'ZAR',
  subAccount: 'test_subaccount',
  transactionCharge: 0,
  bearer: 'account',
  reference: 'test_reference',
};

Paystack.chargeCard(paymentParams);
```

### Full Example

```tsx
import React, { useState } from 'react';
import { View, Button, TextInput } from 'react-native';
import Paystack from 'paystack-react-native';

const PaymentScreen = () => {
  const publicKey = 'YOUR_PAYSTACK_PUBLIC_KEY';
  const [cardNumber, setCardNumber] = useState('');
  const [expiryMonth, setExpiryMonth] = useState('');
  const [expiryYear, setExpiryYear] = useState('');
  const [cvc, setCvc] = useState('');
  const [email, setEmail] = useState('');
  const [amount, setAmount] = useState('');
  const [currency, setCurrency] = useState('ZAR');
  const [subAccount, setSubAccount] = useState('');
  const [transactionCharge, setTransactionCharge] = useState(0);
  const [bearer, setBearer] = useState('');
  const [reference, setReference] = useState('');

  const handleInitSdk = () => {
    Paystack.initSdk(publicKey);
  };

  const handleChargeCard = () => {
    const paymentParams = {
      cardNumber: Number(cardNumber),
      expiryMonth,
      expiryYear,
      cvc,
      email,
      amount: Number(amount),
      currency,
      subAccount,
      transactionCharge,
      bearer,
      reference,
    };

    Paystack.chargeCard(paymentParams);
  };

  return (
    <View>
      <TextInput
        placeholder="Card Number"
        value={cardNumber}
        onChangeText={setCardNumber}
      />
      <TextInput
        placeholder="Expiry Month"
        value={expiryMonth}
        onChangeText={setExpiryMonth}
      />
      <TextInput
        placeholder="Expiry Year"
        value={expiryYear}
        onChangeText={setExpiryYear}
      />
      <TextInput placeholder="CVC" value={cvc} onChangeText={setCvc} />
      <TextInput placeholder="Email" value={email} onChangeText={setEmail} />
      <TextInput placeholder="Amount" value={amount} onChangeText={setAmount} />
      <TextInput
        placeholder="Currency"
        value={currency}
        onChangeText={setCurrency}
      />
      <TextInput
        placeholder="Sub Account"
        value={subAccount}
        onChangeText={setSubAccount}
      />
      <TextInput
        placeholder="Transaction Charge"
        value={transactionCharge.toString()}
        onChangeText={setTransactionCharge}
      />
      <TextInput placeholder="Bearer" value={bearer} onChangeText={setBearer} />
      <TextInput
        placeholder="Reference"
        value={reference}
        onChangeText={setReference}
      />
      <Button title="Initialize SDK" onPress={handleInitSdk} />
      <Button title="Charge Card" onPress={handleChargeCard} />
    </View>
  );
};

export default PaymentScreen;
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

Paystack-React-Native is licensed under the MIT License. See the [LICENSE](https://github.com/Abantu-Digital/paystack-react-native.git)
