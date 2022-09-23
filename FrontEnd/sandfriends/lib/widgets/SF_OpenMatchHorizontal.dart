import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import 'SF_Button.dart';

class SFOpenMatchHorizontal extends StatelessWidget {
  const SFOpenMatchHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.02,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      width: width * 0.6,
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
            decoration: BoxDecoration(
              color: AppTheme.colors.secondaryYellow,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(right: width * 0.02),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: width * 0.2,
                          child: CircleAvatar(
                            backgroundColor: AppTheme.colors.primaryBlue,
                            radius: 30,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.colors.secondaryPaper,
                              radius: 28,
                              child: CircleAvatar(
                                backgroundColor: AppTheme.colors.primaryBlue,
                                radius: 25,
                                child: Container(
                                  height: 20,
                                  width: 23,
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
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                "Partida de\n Arthur",
                                style: TextStyle(
                                  color: AppTheme.colors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: width * 0.2,
                        ),
                        Expanded(
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
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
                                  padding: EdgeInsets.only(right: width * 0.02),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                      "restam 2 vagas",
                                      style: TextStyle(
                                        color: AppTheme.colors.primaryBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\calendar.svg',
                          color: AppTheme.colors.primaryBlue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
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
                          padding: EdgeInsets.only(right: width * 0.01),
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
                      padding: EdgeInsets.only(right: width * 0.01),
                    ),
                    Text(
                      "Point Sul Beach Tenis",
                      style: TextStyle(
                        color: AppTheme.colors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                SFButton(
                    buttonLabel: "Quero jogar",
                    buttonType: ButtonType.Secondary,
                    iconPath: r'assets\icon\user_plus.svg',
                    onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
