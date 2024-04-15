import 'package:flutter/material.dart';

import '../../../../Common/Utils/Constants.dart';

class PaymentDetails extends StatelessWidget {
  String total;
  String paid;
  String remaining;
  PaymentDetails({
    required this.total,
    required this.paid,
    required this.remaining,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "total",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                total,
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 30,
          color: divider,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "pago",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                paid,
                style: TextStyle(
                  color: greenText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 30,
          color: divider,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "pendente",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                remaining,
                style: TextStyle(
                  color: redText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
