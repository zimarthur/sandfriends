import 'package:flutter/material.dart';
import '../Model/SelectedPayment.dart';
import '../Utils/Constants.dart';

class SFPaymentStatus extends StatelessWidget {
  SelectedPayment selectedPayment;
  SFPaymentStatus({super.key, required this.selectedPayment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 4,
      ),
      decoration: BoxDecoration(
          color:
              selectedPayment == SelectedPayment.PayInStore ? redBg : greenBg,
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          )),
      child: Text(
        selectedPayment == SelectedPayment.PayInStore
            ? "Pag. no local"
            : "Pago",
        style: TextStyle(
            color: selectedPayment == SelectedPayment.PayInStore
                ? redText
                : greenText,
            fontSize: 12),
      ),
    );
  }
}
