import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';

class PriceSelectorRadio extends StatefulWidget {
  bool isPriceStandard;
  double height;
  Function(bool?) onChangeIsCustom;

  PriceSelectorRadio({
    super.key,
    required this.isPriceStandard,
    required this.height,
    required this.onChangeIsCustom,
  });

  @override
  State<PriceSelectorRadio> createState() => _PriceSelectorRadioState();
}

class _PriceSelectorRadioState extends State<PriceSelectorRadio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: false,
              groupValue: widget.isPriceStandard,
              onChanged: widget.onChangeIsCustom,
              activeColor: primaryBlue,
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            const Text(
              "Preço único",
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: widget.isPriceStandard,
              onChanged: widget.onChangeIsCustom,
              activeColor: primaryBlue,
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            const Text(
              "Personalizado",
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
