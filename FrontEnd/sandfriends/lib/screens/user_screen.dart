import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../theme/app_theme.dart';

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
                            "${Provider.of<User>(context, listen: false).FirstName![0].toUpperCase()}${Provider.of<User>(context, listen: false).LastName![0].toUpperCase()}",
                            style: TextStyle(
                                color: AppTheme.colors.secondaryBack,
                                fontWeight: FontWeight.w600,
                                fontSize: 44),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "${Provider.of<User>(context, listen: false).FirstName} ${Provider.of<User>(context, listen: false).LastName}",
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
                                color: AppTheme.colors.secondaryPaper,
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
                              Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "BT:",
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
                                        Provider.of<User>(context,
                                                        listen: false)
                                                    .Rank ==
                                                null
                                            ? "-"
                                            : "${Provider.of<User>(context, listen: false).Rank}",
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
                                      "FV:",
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
                                      "VL:",
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
                  UserButtons(context, "Meu perfil", r'assets\icon\user.svg',
                      context.goNamed,
                      functionParameter: 'user_detail'),
                  UserButtons(context, "Minhas partidas",
                      r'assets\icon\trophy.svg', context.goNamed,
                      functionParameter: 'user_detail'),
                  UserButtons(context, "Configurar pagamentos",
                      r'assets\icon\payment.svg', context.goNamed,
                      functionParameter: 'user_detail'),
                  UserButtons(context, "Fale com a gente",
                      r'assets\icon\chat.svg', context.goNamed,
                      functionParameter: 'user_detail'),
                  UserButtons(context, "Sair", r'assets\icon\logout.svg',
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
                SvgPicture.asset(
                  iconPath,
                  height: height * 0.45 * 0.07,
                  color: AppTheme.colors.secondaryPaper,
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
