import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFTextField.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/Validators.dart';

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
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 1,
              width: double.infinity,
              color: divider,
            ),
          ),
          CheckoutPaymentRadio(
            radioPaymentValue: SelectedPayment.PayInStore,
            iconPath: r"assets\icon\dollar_bill.svg",
            title: "Pagar no local",
            subtitle: null,
          ),
          SizedBox(
            height: defaultPadding * 2,
          ),
          Text(
            "CPF na nota fiscal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.3,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          SFTextField(
            labelText: "",
            pourpose: TextFieldPourpose.Numeric,
            controller: Provider.of<CheckoutViewModel>(context, listen: false)
                .cpfController,
            validator: (value) => cpfValidator(value),
          ),
        ],
      ),
    );
  }
}
