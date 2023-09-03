import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarItem.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../ViewModel/CheckoutViewModel.dart';

class CheckoutBottomToolbar extends StatelessWidget {
  const CheckoutBottomToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: secondaryPaper,
        boxShadow: [
          BoxShadow(
            color: textLightGrey,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: divider,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding / 2,
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "O que você está levando",
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          for (var date
              in Provider.of<CheckoutViewModel>(context, listen: false)
                  .matchDates)
            CheckoutBottomToolbarItem(
              date: date,
              price: Provider.of<CheckoutViewModel>(context, listen: false)
                  .matchPrice,
            ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Container(
            color: divider,
            height: 1,
            width: double.infinity,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "R\$ ${Provider.of<CheckoutViewModel>(context, listen: false).totalPrice},00",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          SFButton(
            buttonLabel: Provider.of<CheckoutViewModel>(context, listen: false)
                        .selectedPayment !=
                    SelectedPayment.NotSelected
                ? "Agendar"
                : "Selecione a forma de pagamento",
            color: Provider.of<CheckoutViewModel>(context, listen: false)
                        .selectedPayment !=
                    SelectedPayment.NotSelected
                ? primaryBlue
                : divider,
            onTap: () => Provider.of<CheckoutViewModel>(context, listen: false)
                .validateReservation(context),
            textPadding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
