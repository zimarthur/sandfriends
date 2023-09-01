import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/PageStatus.dart';

import 'CheckoutInfo/CheckoutResume.dart';
import 'Payment/CheckoutPayment.dart';
import 'Toolbar/CheckoutBottomToolbar.dart';

class CheckoutWidget extends StatefulWidget {
  CheckoutViewModel viewModel;
  CheckoutWidget({
    required this.viewModel,
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckoutResume(),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  CheckoutPayment(),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        CheckoutBottomToolbar(),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
      ],
    );
  }
}
