import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Checkout/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CheckoutPayment extends StatefulWidget {
  const CheckoutPayment({Key? key}) : super(key: key);

  @override
  State<CheckoutPayment> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutPayment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Forma de pagamento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.3,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          CheckoutPaymentRadio(
            radioPaymentValue: SelectedPayment.Pix,
            iconPath: r"assets\icon\pix.svg",
            title: "Pix",
          ),
          CheckoutPaymentRadio(
            radioPaymentValue: SelectedPayment.CreditCard,
            iconPath: r"assets\icon\credit_card.svg",
            title: "Cartão de crédito",
            subtitle: null,
          ),
        ],
      ),
    );
  }
}
