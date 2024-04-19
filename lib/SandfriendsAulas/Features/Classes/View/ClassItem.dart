import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Model/HourPrice/HourPriceUser.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassItem extends StatelessWidget {
  AppRecurrentMatchUser? recMatch;
  AppMatchUser? match;
  Team team;
  bool showDate;
  bool showConfirmationStatus;
  bool canRenewRecurrentMatch;
  ClassItem({
    this.recMatch,
    this.match,
    required this.team,
    this.showDate = false,
    this.showConfirmationStatus = false,
    this.canRenewRecurrentMatch = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Court court = match != null ? match!.court : recMatch!.court;
    bool isUserInMatch = match == null
        ? false
        : match!.classMembers.any((member) =>
            member.user.id ==
            Provider.of<UserProvider>(context, listen: false).user!.id);
    return GestureDetector(
      onTap: () {
        if (match != null) {
          Navigator.pushNamed(context, '/partida/${match!.matchUrl}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
        ),
        padding: EdgeInsets.all(4), //borda
        margin: EdgeInsets.symmetric(
          vertical: defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(
                defaultPadding / 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      match != null && showDate
                          ? match!.date.formatDate()
                          : team.name,
                      style: TextStyle(
                        color: textWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (match != null)
                    match!.canceled
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              color: red,
                            ),
                            padding: EdgeInsets.all(
                              defaultPadding / 4,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/x_circle.svg",
                                  color: textWhite,
                                  height: 15,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  "Aula cancelada",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textWhite,
                                  ),
                                )
                              ],
                            ),
                          )
                        : showConfirmationStatus
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorderRadius,
                                  ),
                                  color: isUserInMatch
                                      ? green
                                      : secondaryYellowDark,
                                ),
                                padding: EdgeInsets.all(
                                  defaultPadding / 4,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/${isUserInMatch ? 'check_circle' : 'x_circle'}.svg",
                                      color: textWhite,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Text(
                                      isUserInMatch
                                          ? "Confirmei!"
                                          : "Não confirmei",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: textWhite,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: textWhite,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
              ),
              //height: 115,
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding / 2,
                horizontal: defaultPadding / 4,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SFAvatarStore(
                        height: 70,
                        enableShadow: true,
                        storeName: court.store?.name,
                        storePhoto: court.store?.logo,
                      ),
                      SizedBox(
                        width: defaultPadding / 4,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              court.store!.name,
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                              maxLines: 1,
                              minFontSize: 10,
                              maxFontSize: 14,
                            ),
                            SizedBox(
                              height: defaultPadding / 4,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: showConfirmationStatus
                                  ? [
                                      Text(
                                        "Prof:",
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        team.teacher!.firstName!,
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "Turma:",
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        team.name,
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ]
                                  : [
                                      Text(
                                        team.sport.description,
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        team.rank.name,
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        team.gender.name,
                                        style: TextStyle(
                                          color: textLightGrey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                            ),
                            SizedBox(
                              height: defaultPadding / 4,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match != null
                                ? match!.matchHourDescription
                                : recMatch!.matchHourDescription,
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding / 4,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                match != null
                                    ? "${match!.classMembers.length} confirmado${match!.classMembers.length == 1 ? '' : 's'}"
                                    : "${team.members.length} aluno${team.members.length == 1 ? '' : 's'}",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 10,
                                ),
                              ),
                              Builder(
                                builder: (layoutContext) {
                                  List<dynamic> users = match != null
                                      ? match!.classMembers
                                      : team.members;
                                  double iconSize = 45;
                                  int maxAvatars = 4;
                                  double offsetOnAvatar = 0.7;
                                  int totalAvatarsDisplayed =
                                      users.length > maxAvatars
                                          ? maxAvatars
                                          : users.length;
                                  double width = (totalAvatarsDisplayed *
                                          offsetOnAvatar *
                                          iconSize) +
                                      ((1 - offsetOnAvatar) * iconSize);
                                  return SizedBox(
                                    height: iconSize,
                                    width: width,
                                    child: Stack(
                                      children: [
                                        for (int index = 0;
                                            index < totalAvatarsDisplayed;
                                            index++)
                                          Positioned(
                                            left: index *
                                                offsetOnAvatar *
                                                iconSize,
                                            child: SFAvatarUser(
                                              height: iconSize,
                                              user: users[index].user,
                                              showRank: false,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      match != null
                          ? match!.classMemberDescription
                          : team.membersDescription,
                      style: TextStyle(
                        color: textLightGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  if (recMatch != null && canRenewRecurrentMatch)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: defaultPadding,
                            ),
                            color: divider,
                            height: 1,
                            width: double.infinity,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Renovação",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  List<HourPriceUser> hourPrices = [];
                                  Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .hours
                                      .forEach((hour) {
                                    if (hour.hour >= recMatch!.timeBegin.hour &&
                                        hour.hour < recMatch!.timeEnd.hour) {
                                      hourPrices.add(
                                        HourPriceUser(
                                          hour: hour,
                                          price: recMatch!
                                              .nextRecurrentMatches.first.cost
                                              .toInt(),
                                        ),
                                      );
                                    }
                                  });
                                  Provider.of<StandardScreenViewModel>(context,
                                          listen: false)
                                      .setLoading();
                                  Navigator.pushNamed(
                                    context,
                                    "/checkout",
                                    arguments: {
                                      'court': recMatch!.court,
                                      'hourPrices': hourPrices,
                                      'sport': recMatch!.sport,
                                      'date': null,
                                      'weekday': recMatch!.weekday,
                                      'isRecurrent': true,
                                      'isRenovating': true,
                                      'team': team,
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryBlue,
                                    borderRadius: BorderRadius.circular(
                                      defaultBorderRadius,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: defaultPadding / 4,
                                    horizontal: defaultPadding / 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        r"assets/icon/recurrent_clock.svg",
                                        color: textWhite,
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Text(
                                        "Renovar",
                                        style: TextStyle(
                                          color: textWhite,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "últ. renovação",
                                      style: TextStyle(
                                        color: textLightGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      recMatch!.lastPaymentDate.formatDate(),
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "vencimento",
                                      style: TextStyle(
                                        color: textLightGrey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      recMatch!.validUntil!.formatDate(),
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                    Text(
                                      "${getDaysToEndOfMonth()} dia(s)",
                                      style: TextStyle(
                                        color: secondaryYellowDark,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
