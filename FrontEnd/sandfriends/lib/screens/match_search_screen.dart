import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sandfriends/widgets/SF_SearchFilter.dart';
import '../models/enums.dart';

import '../../models/enums.dart';
import '../../widgets/SF_Dropdown.dart';
import '../../providers/login_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';
import '../providers/match_provider.dart';

class MatchSearchScreen extends StatefulWidget {
  MatchSearchScreen({Key? key}) : super(key: key);

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreen();
}

class _MatchSearchScreen extends State<MatchSearchScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBarHeight = height * 0.3 > 184 ? 184 : height * 0.3;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.colors.primaryBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: appBarHeight * 0.17,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: width * 0.2,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              context.goNamed('home', params: {
                                'initialPage': 'sport_selection_screen'
                              });
                            },
                            child: SvgPicture.asset(
                              r'assets\icon\arrow_left.svg',
                              height: 8.7,
                              width: 13.2,
                              color: AppTheme.colors.secondaryPaper,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Busca - ${Provider.of<Match>(context, listen: false).matchSport!.toShortString()}",
                        style: TextStyle(
                          color: AppTheme.colors.textWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: appBarHeight * 0.06),
                  height: appBarHeight * 0.26,
                  child: SFSearchFilter(
                    labelText: "Porto Alegre / RS",
                    iconPath: r"assets\icon\location_ping.svg",
                    margin: EdgeInsets.only(left: width * 0.02),
                    padding:
                        EdgeInsets.symmetric(vertical: appBarHeight * 0.02),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: appBarHeight * 0.06),
                        height: appBarHeight * 0.26,
                        child: SFSearchFilter(
                          labelText: "09-09 jun",
                          iconPath: r"assets\icon\calendar.svg",
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.symmetric(
                              vertical: appBarHeight * 0.02),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: appBarHeight * 0.06),
                        height: appBarHeight * 0.26,
                        child: SFSearchFilter(
                          labelText: "13h-14h",
                          iconPath: r"assets\icon\clock.svg",
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.symmetric(
                              vertical: appBarHeight * 0.02),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: appBarHeight * 0.06),
                  height: appBarHeight * 0.26,
                  child: SFButton(
                      buttonLabel: "Buscar",
                      buttonType: ButtonType.Secondary,
                      iconPath: r"assets\icon\search.svg",
                      textPadding:
                          EdgeInsets.symmetric(vertical: appBarHeight * 0.02),
                      onTap: () {
                        Provider.of<Match>(context, listen: false).matchSport =
                            Sport.volei;
                        context.goNamed('match_search_screen');
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: AppTheme.colors.secondaryBack,
        width: double.infinity,
        height: height - appBarHeight,
        child: Center(
          child: Container(
            height: height * 0.2,
            padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  r"assets\icon\happy_face.svg",
                  height: height * 0.1,
                ),
                Container(
                  height: height * 0.05,
                  child: Text(
                    "Use os filtros para buscar por quadras e partidas disponíveis.",
                    style: TextStyle(
                      color: AppTheme.colors.textBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.01 > 4 ? 4 : height * 0.01,
                  width: width * 0.8,
                  color: AppTheme.colors.divider,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
