import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/TypeExtensions.dart';

import '../../../../Utils/SFDateTime.dart';
import 'CheckoutDetailsItem.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Partida",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1.3,
        ),
        Padding(
          padding: const EdgeInsets.all(
            defaultPadding / 2,
          ),
          child: Column(
            children: [
              CheckoutDetailsItem(
                title: Provider.of<CheckoutViewModel>(context, listen: false)
                        .isRecurrent
                    ? "Dia"
                    : "Data",
                value: Provider.of<CheckoutViewModel>(context, listen: false)
                        .isRecurrent
                    ? weekDaysPortuguese[
                        Provider.of<CheckoutViewModel>(context, listen: false)
                            .weekday]
                    : DateFormat("dd/MM/yyyy")
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
                  value: Provider.of<CheckoutViewModel>(context, listen: false)
                      .matchPrice
                      .formatPrice()),
            ],
          ),
        ),
      ],
    );
  }
}
