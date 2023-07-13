import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';

class EmptyCreditCards extends StatelessWidget {
  const EmptyCreditCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutContraints) {
        return SizedBox(
          height: layoutContraints.maxHeight,
          width: layoutContraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                r"assets\icon\no_credit_card.svg",
                width: layoutContraints.maxWidth * 0.3,
                color: textDarkGrey,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Text(
                "Você ainda não cadastrou um cartão de crédito",
                style: TextStyle(color: textDarkGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}