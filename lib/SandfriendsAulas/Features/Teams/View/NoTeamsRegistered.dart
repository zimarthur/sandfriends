import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Components/SFButton.dart';
import '../../../../Common/Utils/Constants.dart';

class NoTeamsRegistered extends StatelessWidget {
  NoTeamsRegistered({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          r"assets/icon/team_color.svg",
          height: 100,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Text(
          "Você não tem turmas cadastradas",
          style: TextStyle(
              color: primaryBlue, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          "Cadastre suas turmas para inserir seus alunos",
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
          buttonLabel: "Criar turma",
          iconFirst: true,
          iconPath: r"assets/icon/plus.svg",
          onTap: () => Navigator.pushNamed(context, "/create_team"),
        ),
      ],
    );
  }
}
