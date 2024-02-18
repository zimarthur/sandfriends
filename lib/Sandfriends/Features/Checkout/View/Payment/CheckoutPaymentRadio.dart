import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class CheckoutPaymentRadio extends StatefulWidget {
  final SelectedPayment radioPaymentValue;
  final String iconPath;
  final String title;
  final String? subtitle;

  const CheckoutPaymentRadio({
    super.key,
    required this.radioPaymentValue,
    required this.iconPath,
    required this.title,
    this.subtitle,
  });

  @override
  State<CheckoutPaymentRadio> createState() => _CheckoutPaymentRadioState();
}

class _CheckoutPaymentRadioState extends State<CheckoutPaymentRadio> {
  @override
  Widget build(BuildContext context) {
    bool isSelectedRadio = widget.radioPaymentValue ==
        Provider.of<CheckoutViewModel>(context, listen: false).selectedPayment;
    return InkWell(
      onTap: () => Provider.of<CheckoutViewModel>(context, listen: false)
          .setNewSelectedPayment(
        widget.radioPaymentValue,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          border: Border.all(
              color: isSelectedRadio ? primaryBlue : textDarkGrey,
              width: isSelectedRadio ? 2 : 1),
        ),
        child: Row(children: [
          SvgPicture.asset(
            widget.iconPath,
            height: 25,
          ),
          const SizedBox(
            width: defaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(color: textDarkGrey),
              ),
              if (widget.subtitle != null)
                Text(
                  widget.subtitle!,
                  style: const TextStyle(color: textDarkGrey, fontSize: 10),
                ),
            ],
          ),
          Expanded(child: Container()),
          Radio(
            value: widget.radioPaymentValue,
            groupValue: Provider.of<CheckoutViewModel>(context, listen: false)
                .selectedPayment,
            onChanged: (selectedPayment) =>
                Provider.of<CheckoutViewModel>(context, listen: false)
                    .setNewSelectedPayment(
              widget.radioPaymentValue,
            ),
            activeColor: primaryBlue,
          )
        ]),
      ),
    );
  }
}