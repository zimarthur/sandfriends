import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import 'CheckoutDetailsItem.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Partida",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1.3,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Padding(
          padding: EdgeInsets.all(
            defaultPadding,
          ),
          child: Column(
            children: [
              CheckoutDetailsItem(
                title: "Data",
                value: DateFormat("dd/MM/yyyy")
                    .format(
                      Provider.of<CheckoutViewModel>(context, listen: false)
                          .date,
                    )
                    .toString(),
              ),
              CheckoutDetailsItem(
                title: "Horário",
                value: Provider.of<CheckoutViewModel>(context, listen: false)
                    .matchPeriod,
              ),
              CheckoutDetailsItem(
                title: "Esporte",
                value: Provider.of<CheckoutViewModel>(context, listen: false)
                    .sport
                    .description,
              ),
              CheckoutDetailsItem(
                  title: "Preço",
                  value:
                      "R\$ ${Provider.of<CheckoutViewModel>(context, listen: false).matchPrice},00"),
            ],
          ),
        ),
      ],
    );
  }
}