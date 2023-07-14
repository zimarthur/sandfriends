import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardCard.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/EmptyCreditCards.dart';

class CreditCardWidget extends StatelessWidget {
  Function(CreditCard)? onSelectedCreditCard;
  CreditCardWidget({
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
                      child: CreditCardCard(
                        creditCard: Provider.of<UserProvider>(context)
                            .creditCards[index],
                        isEditable: true,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
