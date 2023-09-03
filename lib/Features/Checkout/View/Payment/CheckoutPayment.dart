import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFTextField.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/Validators.dart';

import '../../../../SharedComponents/Model/CreditCard/CreditCardUtils.dart';

class CheckoutPayment extends StatefulWidget {
  const CheckoutPayment({Key? key}) : super(key: key);

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Forma de pagamento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.3,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          CheckoutPaymentRadio(
            radioPaymentValue: SelectedPayment.Pix,
            iconPath: r"assets/icon/pix.svg",
            title: "Pix",
          ),
          (Provider.of<CheckoutViewModel>(context).selectedCreditCard != null &&
                  Provider.of<CheckoutViewModel>(context).selectedPayment ==
                      SelectedPayment.CreditCard)
              ? CheckoutPaymentRadio(
                  radioPaymentValue: SelectedPayment.CreditCard,
                  iconPath: creditCardImagePath(
                    Provider.of<CheckoutViewModel>(context)
                        .selectedCreditCard!
                        .cardType,
                  ),
                  title: Provider.of<CheckoutViewModel>(context)
                              .selectedCreditCard!
                              .cardNickname !=
                          null
                      ? "${Provider.of<CheckoutViewModel>(context).selectedCreditCard!.cardNickname} - Crédito"
                      : "Crédito",
                  subtitle: encryptedCreditCardNumber(
                      Provider.of<CheckoutViewModel>(context)
                          .selectedCreditCard!),
                )
              : CheckoutPaymentRadio(
                  radioPaymentValue: SelectedPayment.CreditCard,
                  iconPath: r"assets/icon/credit_card.svg",
                  title: "Cartão de crédito",
                  subtitle: null,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 1,
              width: double.infinity,
              color: divider,
            ),
          ),
          CheckoutPaymentRadio(
            radioPaymentValue: SelectedPayment.PayInStore,
            iconPath: r"assets/icon/dollar_bill.svg",
            title: "Pagar no local",
            subtitle: null,
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          const Text(
            "CPF na nota fiscal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.3,
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          SFTextField(
            labelText: "",
            pourpose: TextFieldPourpose.Numeric,
            controller: Provider.of<CheckoutViewModel>(context, listen: false)
                .cpfController,
            validator: (value) => cpfValidator(value, null),
          ),
        ],
      ),
    );
  }
}
