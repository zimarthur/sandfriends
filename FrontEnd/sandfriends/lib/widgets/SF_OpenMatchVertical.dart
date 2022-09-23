import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import 'SF_Button.dart';

class SFOpenMatchVertical extends StatelessWidget {
  const SFOpenMatchVertical({Key? key}) : super(key: key);

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
                                        "AZ",
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
                                    "Partida de Arthur",
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
                                          "restam 2 vagas",
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
                                        "17/19/2022",
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
                                        "19:00",
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
                                    "Point Sul Beach Tenis",
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
                      onTap: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
