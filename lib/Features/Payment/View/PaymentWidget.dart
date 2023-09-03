import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SharedComponents/View/CreditCard/CreditCardWidget.dart';
import 'package:sandfriends/Features/Payment/ViewModel/PaymentViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';
import 'package:sandfriends/Utils/Constants.dart';

class PaymentWidget extends StatefulWidget {
  final PaymentViewModel viewModel;
  const PaymentWidget({super.key, required this.viewModel});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Expanded(
            child: CreditCardWidget(
              creditCards: Provider.of<UserProvider>(context).creditCards,
              isEditable: true,
              onDeleteCreditCard: (creditCard) =>
                  widget.viewModel.onDeleteCreditCard(context, creditCard),
            ),
          ),
          SFButton(
            buttonLabel: "Novo cartão de crédito",
            onTap: () => Navigator.pushNamed(context, "/new_credit_card"),
            textPadding:
                const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
