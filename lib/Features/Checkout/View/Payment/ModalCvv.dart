import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../SharedComponents/View/SFTextField.dart';
import '../../../../Utils/Constants.dart';

class ModalCvv extends StatelessWidget {
  const ModalCvv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      padding: EdgeInsets.all(defaultPadding),
      width: width * 0.9,
      child: Form(
        key: Provider.of<CheckoutViewModel>(context, listen: false).cvvFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              child: CreditCardCard(
                  creditCard:
                      Provider.of<CheckoutViewModel>(context, listen: false)
                          .selectedCreditCard!,
                  isEditable: false),
            ),
            SFTextField(
              labelText: "CVV",
              pourpose: TextFieldPourpose.Numeric,
              controller: Provider.of<CheckoutViewModel>(context, listen: false)
                  .cvvController,
              validator: (a) => validateCVV(a),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
            SFButton(
              buttonLabel: "Concluído",
              textPadding: EdgeInsets.symmetric(
                vertical: defaultPadding / 2,
              ),
              onTap: () =>
                  Provider.of<CheckoutViewModel>(context, listen: false)
                      .makeReservation(context),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
          ],
        ),
      ),
    );
  }
}
