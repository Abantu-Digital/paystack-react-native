

@objc(PaystackReactNative)
class PaystackReactNative: NSObject {
    
var paystackModule = PaystackreactNativeModule();

  @objc(initSdk:publicKey:)
    func initSdk(_name: String, publicKey: String) -> Void {
        Paystack.setDefaultPublicKey(publicKey)
  }
    
    func isCardNumberValid(cardNumber: String, validateCardBrand: Bool) -> Bool {
        return PSTCKCardValidator.validationState(forNumber: cardNumber, validatingCardBrand: validateCardBrand) == PSTCKCardValidationState.valid
    }
    
    func isExpiryMonthValid(expiryMonth: String) -> Bool {
        return PSTCKCardValidator.validationState(forExpirationMonth: expiryMonth) == PSTCKCardValidationState.valid
    }
    
    func isExpiryYearValid(expiryYear: String, expiryMonth: String) -> Bool {
        return PSTCKCardValidator.validationState(forExpirationYear: expiryYear, inMonth: expiryMonth) == PSTCKCardValidationState.valid
    }
    
    func isCvcValid(cvc: String, cardNumber: String) -> Bool {
        var cardBrand = PSTCKCardValidator.brand(forNumber: cardNumber)
        return PSTCKCardValidator.validationState(forCVC: cvc, cardBrand: cardBrand) == PSTCKCardValidationState.valid
    }
    
    func isCardValid(card: PSTCKCardParams) -> Bool {
        return PSTCKCardValidator.validationState(forCard: card) == PSTCKCardValidationState.valid
    }
    
    func handleError(code: String, message: String, reject: RCTPromiseRejectBlock) {
        reject(code,message, nil)
    }
 
    func cardParamsAreValid(cardNumber: String, expiryMonth: String, expiryYear: String, cvc: String) -> Bool {
        
        
        if (!self.isCardNumberValid(cardNumber: cardNumber, validateCardBrand: true)) {
            paystackModule.errorMsg = "Invalid card number. Please try again or try using a different card."
            return false
        }
        
        if (!self.isExpiryMonthValid(expiryMonth: expiryMonth)) {
            paystackModule.errorMsg = "Invalid expiration month. Please try again or try using a different card."
            return false
        }
        
        if (!self.isExpiryYearValid(expiryYear: expiryYear, expiryMonth: expiryMonth)) {
            paystackModule.errorMsg = "Invalid expiration year. Please try again or try using a different card."
            return false
        }
        if (!self.isCvcValid(cvc: cvc, cardNumber: cardNumber)) {
            paystackModule.errorMsg = "Invalid CVC. Please try again or try using a different card."
            return false
        }
        
        return true
    }

  @objc(chargeCard:paymentParams:resolve:reject:)
    func chargeCard(_name: String, paymentParams: NSDictionary, resolve: @escaping(RCTPromiseResolveBlock), reject: @escaping(RCTPromiseRejectBlock)) -> Void {
        
        if let window = UIApplication.shared.windows.first {
            let rootViewController = window.rootViewController
            
            
            var cardNumber = paymentParams["cardNumber"] as! String
            var expiryMonth = paymentParams["expiryMonth"] as! String
            var expiryYear = paymentParams["expiryYear"] as! String
            var cvc = paymentParams["cvc"] as! String
            
            var amount = paymentParams["amount"] as! UInt
            var currency = paymentParams["currency"] as! String
            var email = paymentParams["email"] as! String
            var plan = paymentParams["plan"] as! String
            var subAccount = paymentParams["subAccount"] as! String
            var bearer = paymentParams["bearer"] as! String
            var transactionCharge = paymentParams["transactionCharge"] as! Int
            var reference = paymentParams["reference"] as! String
            
            
            var areCardParamsValid = self.cardParamsAreValid(cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cvc: cvc)
            
            if (!areCardParamsValid) {
                return handleError(code: "Invalid_card", message :paystackModule.errorMsg, reject: reject)
            }
            
            var cardParams = PSTCKCardParams.init()
            cardParams.number = cardNumber
            cardParams.expYear = UInt(expiryYear) ?? 0
            cardParams.expMonth = UInt(expiryMonth) ?? 0
            cardParams.cvc = cvc
            
            var transactionParams = PSTCKTransactionParams.init()
            transactionParams.amount = amount
            transactionParams.currency = currency
            transactionParams.email = email
            
            if (!plan.isEmpty) {
                transactionParams.plan = plan
            }
            
            if (!subAccount.isEmpty) {
                if (!bearer.isEmpty) {
                    transactionParams.bearer = bearer
                }
                
                transactionParams.transaction_charge = transactionCharge
            }
            
            if (!reference.isEmpty) {
                transactionParams.reference = reference
            }
            
            if(!isCardValid(card: cardParams)) {
                
                return handleError(code: "Invalid_card", message :"Invalid card details provided, please try again or use a different card.", reject: reject)
               
            }
            
            PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: rootViewController!,
                didEndWithError: { (error, _reference) -> Void in
               
                self.handleError(code: "Invalid_card", message :"Invalid card details provided, please try again or use a different card.", reject: reject)

            }, didRequestValidation: { (reference) -> Void in
                // an OTP was requested, transaction has not yet succeeded
            }, didTransactionSuccess: { (reference) -> Void in
                // transaction may have succeeded, please verify on backend
                resolve(reference)
            })
            
        }


  }
}
