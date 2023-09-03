import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';

class EmptyCreditCards extends StatelessWidget {
  const EmptyCreditCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutContraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              r"assets/icon/no_credit_card.svg",
              width: layoutContraints.maxWidth * 0.3,
              color: textDarkGrey,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              "Você ainda não cadastrou um cartão de crédito",
              style: TextStyle(color: textDarkGrey),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
