import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Components/SFButton.dart';
import '../../../../Common/Utils/Constants.dart';

class NoPlansRegistered extends StatelessWidget {
  VoidCallback onRegisterPlans;
  NoPlansRegistered({
    required this.onRegisterPlans,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          r"assets/icon/class_plans_color.svg",
          height: 100,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Text(
          "Você não tem planos cadastrados",
          style: TextStyle(
              color: primaryBlue, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          "Cadastre seus planos por modalidade para iniciar com as aulas",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: textDarkGrey,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 2 * defaultPadding,
        ),
        SFButton(
          buttonLabel: "Cadastrar planos",
          iconFirst: true,
          iconPath: r"assets/icon/config.svg",
          onTap: () => onRegisterPlans(),
        ),
      ],
    );
  }
}
