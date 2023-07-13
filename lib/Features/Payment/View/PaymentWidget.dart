import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/EmptyCreditCards.dart';
import 'package:sandfriends/Features/Payment/ViewModel/PaymentViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';
import 'package:sandfriends/Utils/Constants.dart';

class PaymentWidget extends StatefulWidget {
  PaymentViewModel viewModel;
  PaymentWidget({required this.viewModel});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Expanded(
            child: widget.viewModel.creditCards.isEmpty
                ? EmptyCreditCards()
                : Container(),
          ),
          SFButton(
            buttonLabel: "Novo cartão de crédito",
            onTap: () => Navigator.pushNamed(context, "/new_credit_card"),
            textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
