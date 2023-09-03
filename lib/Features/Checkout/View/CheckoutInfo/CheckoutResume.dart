import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/View/CheckoutInfo/CheckoutDetails.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/SharedComponents/View/StoreSection.dart';
import 'package:sandfriends/Utils/Constants.dart';

class CheckoutResume extends StatelessWidget {
  const CheckoutResume({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      margin: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
        border: Border.all(
          color: textDarkGrey,
        ),
        boxShadow: const [
          BoxShadow(
            color: textLightGrey,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: StoreSection(
              fullAddress: false,
              court:
                  Provider.of<CheckoutViewModel>(context, listen: false).court,
              onTapStore: () {},
            ),
          ),
          Container(
            height: 2,
            width: double.infinity,
            color: divider,
            margin: const EdgeInsets.symmetric(vertical: defaultPadding),
          ),
          const CheckoutDetails(),
        ],
      ),
    );
  }
}
