import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardWidget.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';

import '../../../../Utils/Constants.dart';

class ModalCreditCardSelector extends StatelessWidget {
  Function(CreditCard) onSelectedCreditCard;
  ModalCreditCardSelector({
    required this.onSelectedCreditCard,
  });

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
      height: height * 0.6,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
                vertical: defaultPadding,
              ),
              child: CreditCardWidget(
                onSelectedCreditCard: (creditCard) =>
                    onSelectedCreditCard(creditCard),
              ),
            ),
          ),
          SFButton(
            buttonLabel: "Novo cartão de crédito",
            onTap: () => Navigator.pushNamed(context, "/new_credit_card"),
            textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
    ;
  }
}
