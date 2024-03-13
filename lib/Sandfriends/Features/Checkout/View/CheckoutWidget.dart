import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

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
              child: Column(
                children: [
                  const CheckoutResume(),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  CheckoutPayment(
                    viewModel: widget.viewModel,
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        CheckoutBottomToolbar(
          viewModel: widget.viewModel,
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
      ],
    );
  }
}
