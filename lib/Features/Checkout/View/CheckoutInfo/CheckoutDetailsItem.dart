import 'package:flutter/material.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CheckoutDetailsItem extends StatelessWidget {
  final String title;
  final String value;
  const CheckoutDetailsItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textDarkGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: textDarkGrey,
            ),
          )
        ],
      ),
    );
  }
}
