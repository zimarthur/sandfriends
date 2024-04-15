import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassItem extends StatelessWidget {
  AppRecurrentMatchUser? recMatch;
  AppMatchUser? match;
  Team team;
  bool showDate;
  bool showConfirmationStatus;
  ClassItem({
    this.recMatch,
    this.match,
    required this.team,
    this.showDate = false,
    this.showConfirmationStatus = false,
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
                  if (showConfirmationStatus)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          color: isUserInMatch ? green : red),
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
                            isUserInMatch ? "Confirmei!" : "Não confirmei",
                            style: TextStyle(
                              fontSize: 10,
                              color: textWhite,
                            ),
                          )
                        ],
                      ),
                    )
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
              height: 115,
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding / 2,
                horizontal: defaultPadding / 4,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
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
                            Expanded(
                              child: Column(
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
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder:
                                          (layoutContext, layoutConstraints) {
                                        List<dynamic> users = match != null
                                            ? match!.classMembers
                                            : team.members;
                                        double iconSize =
                                            layoutConstraints.maxHeight * 0.85;
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
                                          height: layoutConstraints.maxHeight,
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
