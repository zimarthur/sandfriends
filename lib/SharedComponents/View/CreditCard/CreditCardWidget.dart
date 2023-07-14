import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/EmptyCreditCards.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CreditCardWidget extends StatelessWidget {
  bool isEditable;
  Function(CreditCard)? onSelectedCreditCard;
  CreditCardWidget({
    required this.isEditable,
    this.onSelectedCreditCard,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutContraints) {
        return SizedBox(
          width: layoutContraints.maxWidth,
          height: layoutContraints.maxHeight,
          child: Provider.of<UserProvider>(context).creditCards.isEmpty
              ? const EmptyCreditCards()
              : ListView.builder(
                  itemCount:
                      Provider.of<UserProvider>(context).creditCards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (onSelectedCreditCard != null) {
                          onSelectedCreditCard!(
                            Provider.of<UserProvider>(context, listen: false)
                                .creditCards[index],
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: index ==
                                    Provider.of<UserProvider>(context)
                                            .creditCards
                                            .length -
                                        1
                                ? 0
                                : defaultPadding),
                        child: CreditCardCard(
                          creditCard: Provider.of<UserProvider>(context)
                              .creditCards[index],
                          isEditable: isEditable,
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
