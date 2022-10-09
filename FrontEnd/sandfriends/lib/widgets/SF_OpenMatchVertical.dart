import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../models/match.dart';
import 'SF_Button.dart';

class SFOpenMatchVertical extends StatelessWidget {
  final Match match;

  SFOpenMatchVertical({required this.match});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 170,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.01,
      ),
      padding: EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.colors.secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.colors.divider,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            margin: EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.colors.secondaryYellow,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 105,
                  child: Row(
                    children: [
                      Container(
                        width: 92,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.colors.primaryBlue,
                              radius: 36,
                              child: CircleAvatar(
                                backgroundColor: AppTheme.colors.secondaryPaper,
                                radius: 34,
                                child: CircleAvatar(
                                  backgroundColor: AppTheme.colors.primaryBlue,
                                  radius: 32,
                                  child: Container(
                                    height: 34,
                                    width: 34,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "${match.matchCreator!.firstName![0].toUpperCase()}${match.matchCreator!.lastName![0].toUpperCase()}",
                                        style: TextStyle(
                                          color: AppTheme.colors.secondaryBack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  r'assets\icon\star.svg',
                                  color: AppTheme.colors.primaryBlue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.01),
                                ),
                                Text(
                                  "Iniciante",
                                  style: TextStyle(
                                    color: AppTheme.colors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "Partida de ${match.matchCreator!.firstName}",
                                    style: TextStyle(
                                      color: AppTheme.colors.primaryBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              IntrinsicWidth(
                                child: Container(
                                  height: 24,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.secondaryYellow,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        r'assets\icon\users.svg',
                                        color: AppTheme.colors.primaryBlue,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.02),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          match.remainingSlots == 1
                                              ? "resta 1 vaga"
                                              : "restam ${match.remainingSlots} vagas",
                                          style: TextStyle(
                                            color: AppTheme.colors.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        r'assets\icon\calendar.svg',
                                        color: AppTheme.colors.primaryBlue,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.01),
                                      ),
                                      Text(
                                        "${DateFormat("dd/MM/yyyy").format(match.day!)}",
                                        style: TextStyle(
                                          color: AppTheme.colors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        r'assets\icon\clock.svg',
                                        color: AppTheme.colors.primaryBlue,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.01),
                                      ),
                                      Text(
                                        match.timeBegin,
                                        style: TextStyle(
                                          color: AppTheme.colors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    r'assets\icon\court.svg',
                                    color: AppTheme.colors.primaryBlue,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: width * 0.01),
                                  ),
                                  Text(
                                    match.store!.name,
                                    style: TextStyle(
                                      color: AppTheme.colors.primaryBlue,
                                    ),
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
                Container(
                  height: 30,
                  child: SFButton(
                    buttonLabel: "Quero jogar",
                    iconPath: r'assets\icon\user_plus.svg',
                    buttonType: ButtonType.Secondary,
                    onTap: () {
                      context.goNamed('match_screen', params: {
                        'matchUrl': match.matchUrl,
                        'returnTo': 'match_search_screen',
                        'returnToParam': 'null',
                        'returnToParamValue': 'null',
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
