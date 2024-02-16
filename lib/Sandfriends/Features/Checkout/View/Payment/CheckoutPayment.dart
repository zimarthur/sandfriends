import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../../Common/Model/CreditCard/CreditCardUtils.dart';
import '../../../../../Common/Components/SFTextField.dart';

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
            padding: EdgeInsets.only(
                bottom: defaultPadding / 2, top: defaultPadding / 4),
            child: Row(children: [
              SvgPicture.asset(
                r"assets/icon/star.svg",
                color: secondaryYellow,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: RichText(
                  maxLines: 2,
                  textScaleFactor: 0.8,
                  text: TextSpan(
                    text: 'Pague pelo app para conquistar ',
                    style: const TextStyle(
                      color: textDarkGrey,
                      fontFamily: 'Lexend',
                    ),
                    children: [
                      TextSpan(
                        text: "recompensas",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryYellow,
                          fontFamily: 'Lexend',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
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
          if (Provider.of<CheckoutViewModel>(context).selectedPayment ==
              SelectedPayment.Pix)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller:
                      Provider.of<CheckoutViewModel>(context, listen: false)
                          .cpfController,
                  focusNode:
                      Provider.of<CheckoutViewModel>(context, listen: false)
                          .cpfFocus,
                  validator: (value) => cpfValidator(value, null),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
