import 'package:flutter/material.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CheckoutDetailsItem extends StatelessWidget {
  String title;
  String value;
  CheckoutDetailsItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textDarkGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textDarkGrey,
            ),
          )
        ],
      ),
    );
  }
}
