import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import 'CheckoutInfo/CheckoutResume.dart';
import 'Payment/CheckoutPayment.dart';
import 'Toolbar/CheckoutBottomToolbar.dart';

class CheckoutWidget extends StatefulWidget {
  final CheckoutViewModel viewModel;
  const CheckoutWidget({
    super.key,
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
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: SingleChildScrollView(
              controller: widget.viewModel.scrollController,
              child: const Column(
                children: [
                  CheckoutResume(),
                  SizedBox(
                    height: defaultPadding,
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
        const CheckoutBottomToolbar(),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
      ],
    );
  }
}
