import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/widgets/SF_Button.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';

import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';

class NewUserWelcome extends StatelessWidget {
  bool showModal = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      titleText: "Boas-vindas",
      onTapReturn: () {
        context.goNamed('login_signup');
      },
      appBarType: AppBarType.Secondary,
      showModal: showModal,
      child: Container(
        color: AppTheme.colors.secondaryBack,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.09),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: height * 0.09)),
                  SvgPicture.asset(
                    r'assets\icon\happy_face.svg',
                    height: height * 0.13,
                    width: height * 0.13,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.02)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Boas-vindas,",
                        style: TextStyle(
                          color: AppTheme.colors.textBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "Sandfriend!",
                        style: TextStyle(
                          color: AppTheme.colors.textBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                  Text(
                    "Você está quase pronto para agendar suas partidas e conhecer novos jogadores.",
                    style: TextStyle(
                      color: AppTheme.colors.textBlue,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.015)),
                  Text(
                    "Fale um pouco sobre você e comece a usar o aplicativo.",
                    style: TextStyle(
                      color: AppTheme.colors.textBlue,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.12)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                height: height * 0.05,
                padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                child: SFButton(
                  buttonLabel: "Começar",
                  buttonType: ButtonType.Primary,
                  onTap: () {
                    context.goNamed('new_user_form');
                  },
                ),
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              height: height * 0.06,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(
                  r'assets\icon\sand_bar.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
