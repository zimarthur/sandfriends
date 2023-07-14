import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarItem.dart';
import 'package:sandfriends/SharedComponents/View/SFButton.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../ViewModel/CheckoutViewModel.dart';

class CheckoutBottomToolbar extends StatelessWidget {
  const CheckoutBottomToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding / 2,
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "O que você está levando",
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          CheckoutBottomToolbarItem(
            date: Provider.of<CheckoutViewModel>(context, listen: false).date,
            price: Provider.of<CheckoutViewModel>(context, listen: false)
                .matchPrice,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Container(
            color: divider,
            height: 1,
            width: double.infinity,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "R\$ ${Provider.of<CheckoutViewModel>(context, listen: false).matchPrice},00",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(
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
            textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
