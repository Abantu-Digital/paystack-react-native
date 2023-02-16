interface IPaymentParams {
  cardNumber: number;
  expiryMonth: string;
  expiryYear: string;
  cvc: string;
  email: string;
  amount: number;
  currency: string;
  subAccount: string;
  transactionCharge: number; // How much commission are we charging
  bearer: string;
  reference: string;
}

export type { IPaymentParams };
