import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/EmptyCreditCards.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CreditCardWidget extends StatefulWidget {
  bool isEditable;
  Function(CreditCard)? onSelectedCreditCard;
  Function(CreditCard)? onDeleteCreditCard;
  List<CreditCard> creditCards;
  CreditCardWidget({
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
