import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';

class PriceSelectorHeader extends StatelessWidget {
  bool allowRecurrent;

  PriceSelectorHeader({
    super.key,
    required this.allowRecurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 3,
          child: Text(
            "Intervalo",
            style: TextStyle(color: textLightGrey),
            textAlign: TextAlign.center,
          ),
        ),
        const Expanded(
          flex: 2,
          child: Text(
            "Avulso",
            style: TextStyle(color: textLightGrey),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: allowRecurrent
              ? const Text(
                  "Mensalista",
                  style: TextStyle(color: textLightGrey),
                  textAlign: TextAlign.center,
                )
              : Container(),
        ),
      ],
    );
  }
}
