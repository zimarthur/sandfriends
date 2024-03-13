import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarDiscount.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Toolbar/CheckoutBottomToolbarItem.dart';
import '../../../../../Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../ViewModel/CheckoutViewModel.dart';

class CheckoutBottomToolbar extends StatelessWidget {
  CheckoutViewModel viewModel;
  CheckoutBottomToolbar({required this.viewModel, Key? key}) : super(key: key);

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
          for (var date in viewModel.matchDates)
            CheckoutBottomToolbarItem(
              date: date,
              price: viewModel.matchPrice,
            ),
          if (!viewModel.isRecurrent &&
              viewModel.selectedPayment != SelectedPayment.PayInStore)
            Column(
              children: [
                const SizedBox(
                  height: defaultPadding / 4,
                ),
                CheckoutBottomToolbarDiscount(
                  viewModel: viewModel,
                ),
              ],
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
                "R\$ ${viewModel.finalMatchPrice.toStringAsFixed(2).replaceAll(".", ",")}",
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
            buttonLabel:
                viewModel.selectedPayment != SelectedPayment.NotSelected
                    ? "Agendar"
                    : "Selecione a forma de pagamento",
            color: viewModel.selectedPayment != SelectedPayment.NotSelected
                ? primaryBlue
                : divider,
            onTap: () => viewModel.validateReservation(context),
            textPadding:
                const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          )
        ],
      ),
    );
  }
}
