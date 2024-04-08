import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassItem extends StatelessWidget {
  AppRecurrentMatchUser? recMatch;
  AppMatchUser? match;
  Team team;
  bool showDate;
  ClassItem({
    this.recMatch,
    this.match,
    required this.team,
    this.showDate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Court court = match != null ? match!.court : recMatch!.court;
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
            Container(
              decoration: BoxDecoration(
                color: textWhite,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
              ),
              height: 110,
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
                              Text(
                                court.store!.name,
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding / 4,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    team.sport.description,
                                    style: TextStyle(
                                      color: textLightGrey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  if (team.rank != null)
                                    Text(
                                      team.rank!.name,
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
