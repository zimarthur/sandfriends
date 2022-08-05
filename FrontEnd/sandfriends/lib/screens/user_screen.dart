import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/enums.dart';
import 'user_detail_screen.dart';
import '../theme/app_theme.dart';
import '../providers/login_provider.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;
    return Container(
      color: AppTheme.colors.primaryBlue,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    child: CircleAvatar(
                      backgroundColor: AppTheme.colors.secondaryGreen,
                      radius: width / 6.7,
                      child: CircleAvatar(
                        backgroundColor: AppTheme.colors.primaryBlue,
                        radius: width / 7.1,
                        child: CircleAvatar(
                          backgroundColor: AppTheme.colors.secondaryGreen,
                          radius: width / 7.6,
                          child: Text(
                            "AB",
                            style: TextStyle(
                                color: AppTheme.colors.secondaryBack,
                                fontWeight: FontWeight.w600,
                                fontSize: 44),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.04,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "Arthur Zim",
                        style: TextStyle(color: AppTheme.colors.textWhite),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                r'assets\icon\location_ping.svg',
                                width: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.02),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "Porto Alegre / RS",
                                    style: TextStyle(
                                        color: AppTheme.colors.textWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                r'assets\icon\location_ping.svg',
                                width: 15,
                              ),
                              Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Beach Tennis:",
                                      style: TextStyle(
                                          color: AppTheme.colors.textWhite),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.01),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "A",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Futvolei:",
                                      style: TextStyle(
                                          color: AppTheme.colors.textWhite),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.01),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Volei:",
                                      style: TextStyle(
                                          color: AppTheme.colors.textWhite),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.01),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: AppTheme.colors.textWhite),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: SvgPicture.asset(
                r'assets\icon\divider.svg',
                width: width * 0.9,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, bottom: height * 0.05),
              height: height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UserButtons(context, "Meu perfil", r'assets\icon\user.png',
                      context.goNamed,
                      functionParameter: UserDetailScreen.routeName),
                  UserButtons(context, "Convide amigos",
                      r'assets\icon\share.png', context.goNamed,
                      functionParameter: 'user_detail'),
                  UserButtons(context, "Minhas partidas",
                      r'assets\icon\trophy.png', context.goNamed,
                      functionParameter: UserDetailScreen.routeName),
                  UserButtons(context, "Configurações",
                      r'assets\icon\configuration.png', context.goNamed,
                      functionParameter: UserDetailScreen.routeName),
                  UserButtons(context, "Sair", r'assets\icon\logout.png',
                      context.goNamed,
                      functionParameter: 'login_signup'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget UserButtons(
    BuildContext context, String title, String iconPath, Function onTapFuncion,
    {var functionParameter}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height - 75;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      highlightColor: AppTheme.colors.primaryDarkBlue,
      onTap: () {
        if (functionParameter == null) {
          onTapFuncion(context);
        } else {
          onTapFuncion(functionParameter);
        }
      },
      child: Ink(
        color: AppTheme.colors.primaryBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  iconPath,
                  height: height * 0.45 * 0.15 > 40 ? 40 : height * 0.45 * 0.15,
                  color: AppTheme.colors.secondaryBack,
                ),
                Container(
                  padding: EdgeInsets.only(left: width * 0.03),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: AppTheme.colors.secondaryBack,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
