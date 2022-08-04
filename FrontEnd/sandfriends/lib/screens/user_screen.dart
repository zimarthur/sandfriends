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
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.colors.secondaryGreen,
                  radius: width / 6,
                  child: CircleAvatar(
                    backgroundColor: AppTheme.colors.primaryBlue,
                    radius: width / 6.4,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.colors.secondaryGreen,
                      radius: width / 6.8,
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
                Text("Arthur Zim"),
                Text("oi"),
                Text("oi"),
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
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.02),
            height: height * 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UserButtons(context, "Meu perfil", r'assets\icon\user.png',
                    context.goNamed,
                    functionParameter: UserDetailScreen.routeName),
                UserButtons(context, "Convide amigos", r'assets\icon\share.png',
                    context.goNamed,
                    functionParameter: 'user_detail'),
                UserButtons(context, "Minhas partidas",
                    r'assets\icon\trophy.png', context.goNamed,
                    functionParameter: UserDetailScreen.routeName),
                UserButtons(context, "Configurações",
                    r'assets\icon\configuration.png', context.goNamed,
                    functionParameter: UserDetailScreen.routeName),
                UserButtons(
                    context, "Sair", r'assets\icon\logout.png', context.goNamed,
                    functionParameter: 'login_signup'),
              ],
            ),
          )
        ],
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    iconPath,
                    height: 40,
                    width: 40,
                    color: AppTheme.colors.secondaryBack,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: width * 0.05),
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
    ),
  );
}
