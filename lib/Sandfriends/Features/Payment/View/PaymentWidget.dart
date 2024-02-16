import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/Sandfriends/Features/Payment/ViewModel/PaymentViewModel.dart';
import '../../../../../Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Components/CreditCard/CreditCardWidget.dart';

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
