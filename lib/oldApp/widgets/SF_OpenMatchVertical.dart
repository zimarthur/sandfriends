import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../../SharedComponents/Model/AppMatch.dart';
import 'SFAvatar.dart';
import 'SF_Button.dart';

class SFOpenMatchVertical extends StatelessWidget {
  final AppMatch match;
  final VoidCallback? buttonCallback;

  const SFOpenMatchVertical(
      {required this.match, required this.buttonCallback});

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
      padding: const EdgeInsets.all(
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
            margin: const EdgeInsets.only(
              right: 12,
            ),
            decoration: BoxDecoration(
              color: Color(int.parse(
                  "0xFF${match.matchCreator.rank.first.color.replaceAll("#", "")}")),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 105,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 92,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SFAvatar(
                              height: 72,
                              showRank: true,
                              user: match.matchCreator,
                              editFile: null,
                              sport: match.sport,
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
                                  match.matchCreator.rank.first.name,
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
                              SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "Partida de ${match.matchCreator.firstName}",
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
                                  padding: const EdgeInsets.symmetric(
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
                                        DateFormat("dd/MM/yyyy")
                                            .format(match.date),
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
                                    match.court.store.name,
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
                SizedBox(
                  height: 30,
                  child: SFButton(
                    buttonLabel: "Quero jogar",
                    iconPath: r'assets\icon\user_plus.svg',
                    buttonType: ButtonType.Secondary,
                    onTap: buttonCallback,
                    // () {
                    //   context.goNamed('match_screen', params: {
                    //     'matchUrl': match.matchUrl,
                    //     'returnTo': 'match_search_screen',
                    //     'returnToParam': 'null',
                    //     'returnToParamValue': 'null',
                    //   });
                    // },
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
