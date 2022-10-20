import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/user.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';

import '../providers/categories_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../models/match.dart';

class UserMatchScreen extends StatefulWidget {
  @override
  State<UserMatchScreen> createState() => _UserMatchScreenState();
}

class _UserMatchScreenState extends State<UserMatchScreen> {
  bool isLoading = true;
  bool showModal = false;
  Widget? modalWidget;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SFScaffold(
      titleText: "Minhas partidas",
      onTapReturn: () {
        context.go('/home/user_screen');
      },
      appBarType: AppBarType.Primary,
      showModal: showModal,
      child: Container(
        color: AppTheme.colors.secondaryBack,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: Provider.of<UserProvider>(context).matchList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.go(
                    '/match_screen/${Provider.of<UserProvider>(context, listen: false).matchList[index].matchUrl}/user_match_screen/null/null');
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.1,
                ),
                height: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.colors.textLightGrey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0),
                    )
                  ],
                  color: AppTheme.colors.secondaryPaper,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: height * 0.17,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                            '${Provider.of<UserProvider>(context).matchList[index].sport!.photoUrl}',
                            width: double.infinity,
                            fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      left: width * 0.02,
                      top: height * 0.09,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              AppTheme.colors.secondaryPaper.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: height * 0.07,
                        width: height * 0.07,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.03,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "${Provider.of<UserProvider>(context).matchList[index].day!.day}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.025,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "${Provider.of<CategoriesProvider>(context, listen: false).monthsPortuguese[Provider.of<UserProvider>(context).matchList[index].day!.month - 1]}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.17,
                      child: Container(
                        padding: EdgeInsets.only(left: width * 0.02),
                        width: width * 0.8,
                        height: height * 0.08,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: height * 0.03,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Partida de ${Provider.of<UserProvider>(context).matchList[index].userCreator}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colors.textBlue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.01),
                              height: height * 0.02,
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets\icon\clock.svg",
                                      color: AppTheme.colors.textDarkGrey,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.01),
                                    ),
                                    Text(
                                      "${Provider.of<UserProvider>(context).matchList[index].timeBegin} - ${Provider.of<UserProvider>(context).matchList[index].timeFinish}",
                                      style: TextStyle(
                                        color: AppTheme.colors.textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.01),
                              height: height * 0.02,
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets\icon\location_ping.svg",
                                      color: AppTheme.colors.textDarkGrey,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.01),
                                    ),
                                    Text(
                                      "${Provider.of<UserProvider>(context).matchList[index].store!.name}",
                                      style: TextStyle(
                                        color: AppTheme.colors.textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ((Provider.of<UserProvider>(context)
                                      .matchList[index]
                                      .day!
                                      .isBefore(DateTime.now())) ||
                                  ((Provider.of<UserProvider>(context)
                                              .matchList[index]
                                              .day!
                                              .day ==
                                          DateTime.now().day) &&
                                      (Provider.of<UserProvider>(context)
                                              .matchList[index]
                                              .timeInt <
                                          DateTime.now().hour)))
                              ? AppTheme.colors.textLightGrey.withOpacity(0.6)
                              : Colors.transparent),
                    ),
                    Provider.of<UserProvider>(context)
                                .matchList[index]
                                .canceled ==
                            true
                        ? Positioned(
                            right: width * 0.02,
                            top: width * 0.02,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: width * 0.01),
                              decoration: BoxDecoration(
                                color: ((Provider.of<UserProvider>(context)
                                            .matchList[index]
                                            .day!
                                            .isBefore(DateTime.now())) ||
                                        ((Provider.of<UserProvider>(context)
                                                    .matchList[index]
                                                    .day!
                                                    .day ==
                                                DateTime.now().day) &&
                                            (Provider.of<UserProvider>(context)
                                                    .matchList[index]
                                                    .timeInt <
                                                DateTime.now().hour)))
                                    ? Colors.red.withOpacity(0.6)
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "Cancelado",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.colors.textWhite,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
