import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../SharedComponents/View/SFTextField.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';

class CvvModal extends StatefulWidget {
  CreditCard selectedCreditCard;
  Function(String) onCvv;
  CvvModal({
    Key? key,
    required this.selectedCreditCard,
    required this.onCvv,
  }) : super(key: key);

  @override
  State<CvvModal> createState() => _CvvModalState();
}

class _CvvModalState extends State<CvvModal> {
  TextEditingController cvvController = MaskedTextController(mask: "0000");
  final cvvFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Form(
        key: cvvFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Digite o cvv do cartão",
              style: TextStyle(
                color: primaryBlue,
              ),
              textScaleFactor: 1.2,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            CreditCardCard(
                creditCard: widget.selectedCreditCard, isEditable: false),
            SizedBox(
              height: defaultPadding,
            ),
            SFTextField(
              labelText: "cvv",
              pourpose: TextFieldPourpose.Numeric,
              controller: cvvController,
              validator: (value) => validateCVV(value),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
            ),
            SFButton(
              buttonLabel: "Concluído",
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () {
                if (cvvFormKey.currentState?.validate() == true) {
                  widget.onCvv(cvvController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
