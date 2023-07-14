import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Utils/Constants.dart';

class CheckoutBottomToolbarItem extends StatelessWidget {
  DateTime date;
  int price;
  CheckoutBottomToolbarItem({
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Partida no dia ${DateFormat("dd/MM").format(date)}",
            style: TextStyle(
              fontSize: 12,
              color: textDarkGrey,
            ),
          ),
          Text(
            "R\$ $price,00",
            style: TextStyle(
              fontSize: 12,
              color: textDarkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
