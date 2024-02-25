import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import 'CreditCardCard.dart';
import 'EmptyCreditCards.dart';

class CreditCardWidget extends StatefulWidget {
  final bool isEditable;
  final Function(CreditCard)? onSelectedCreditCard;
  final Function(CreditCard)? onDeleteCreditCard;
  final List<CreditCard> creditCards;
  const CreditCardWidget({
    super.key,
    required this.creditCards,
    required this.isEditable,
    this.onSelectedCreditCard,
    this.onDeleteCreditCard,
  });

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutContraints) {
        return SizedBox(
          width: layoutContraints.maxWidth,
          height: layoutContraints.maxHeight,
          child: widget.creditCards.isEmpty
              ? const EmptyCreditCards()
              : ListView.builder(
                  itemCount: widget.creditCards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (widget.onSelectedCreditCard != null) {
                          widget.onSelectedCreditCard!(
                            widget.creditCards[index],
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: index == widget.creditCards.length - 1
                                ? 0
                                : defaultPadding),
                        child: CreditCardCard(
                          creditCard: widget.creditCards[index],
                          isEditable: widget.isEditable,
                          onDeleteCreditCard: (creditCard) =>
                              widget.onDeleteCreditCard!(creditCard),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
