import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../Model/CreditCard/CreditCardUtils.dart';

class CreditCardCard extends StatefulWidget {
  CreditCard creditCard;
  bool isEditable;
  CreditCardCard({
    required this.creditCard,
    required this.isEditable,
  });

  @override
  State<CreditCardCard> createState() => _CreditCardCardState();
}

class _CreditCardCardState extends State<CreditCardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: defaultPadding / 4, vertical: defaultPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: divider),
        color: secondaryPaper,
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: divider, offset: Offset(2, 2))
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            creditCardImagePath(
              getCardTypeFrmNumber(
                widget.creditCard.cardNumber,
              ),
            ),
            height: 40,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.creditCard.cardNickname != null)
                      Text("${widget.creditCard.cardNickname!} - "),
                    Text("Crédito"),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 4,
                ),
                Text(
                  encryptedCreditCardNumber(widget.creditCard),
                  style: TextStyle(color: textDarkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
