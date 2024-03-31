import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/ViewModel/TeamDetailsViewModel.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';

class TeamDetailsAbout extends StatelessWidget {
  //TeamDetailsViewModel viewModel;
  TeamDetailsAbout({
    //required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TeamDetailsViewModel viewModel = Provider.of<TeamDetailsViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              r"assets/icon/menu_burger.svg",
              color: primaryLightBlue,
              height: 15,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              "Descrição",
              style: TextStyle(
                color: primaryLightBlue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          viewModel.team.description,
          style: TextStyle(
            color: textDarkGrey,
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: 2 * defaultPadding,
        ),
        Row(
          children: [
            SvgPicture.asset(
              r"assets/icon/info_circle.svg",
              color: primaryLightBlue,
              height: 15,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              "Informações",
              style: TextStyle(
                color: primaryLightBlue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Row(
          children: [
            Text(
              "Esporte: ${viewModel.team.sport.description}",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 12,
              ),
            )
          ],
        ),
        Row(
          children: [
            Text(
              "Categoria: ${viewModel.team.rank != null ? viewModel.team.rank!.name : '-'}",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 12,
              ),
            )
          ],
        ),
        Row(
          children: [
            Text(
              "Gênero: ${viewModel.team.gender.name}",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 12,
              ),
            )
          ],
        ),
        SizedBox(
          height: 2 * defaultPadding,
        ),
        Row(
          children: [
            SvgPicture.asset(
              r"assets/icon/calendar.svg",
              color: primaryLightBlue,
              height: 15,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              "Quando",
              style: TextStyle(
                color: primaryLightBlue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Column(
          children: [
            for (int weekday = 0; weekday < 7; weekday++)
              Builder(
                builder: (context) {
                  List<AppRecurrentMatch> dayRecMatches = viewModel
                      .team.recurrentMatches
                      .where((recMatch) => recMatch.weekday == weekday)
                      .toList();
                  return dayRecMatches.isEmpty
                      ? Container()
                      : Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding / 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weekdayRecurrent[weekday].capitalize(),
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: defaultPadding / 6,
                              ),
                              for (var recMatch in dayRecMatches)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          r"assets/icon/court.svg",
                                          color: textDarkGrey,
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 4,
                                        ),
                                        Text(
                                          recMatch.court.store!.name,
                                          style: TextStyle(
                                            color: textDarkGrey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 6,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          r"assets/icon/clock.svg",
                                          color: textDarkGrey,
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 4,
                                        ),
                                        Text(
                                          recMatch.matchHourDescription,
                                          style: TextStyle(
                                            color: textDarkGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                },
              ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          children: [
            SvgPicture.asset(
              r"assets/icon/user_group.svg",
              color: primaryLightBlue,
              height: 15,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              "Turma (${viewModel.isTeacherCreator ? viewModel.team.membersAndPendinds.length : viewModel.team.acceptedMembers.length})",
              style: TextStyle(
                color: primaryLightBlue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: viewModel.isTeacherCreator
                ? viewModel.team.membersAndPendinds.length
                : viewModel.team.acceptedMembers.length,
            itemBuilder: (context, index) {
              double height = 60;
              TeamMember member = viewModel.isTeacherCreator
                  ? viewModel.team.membersAndPendinds[index]
                  : viewModel.team.acceptedMembers[index];
              User user = member.user;
              bool awaitingApproval = member.waitingApproval;
              return Container(
                height: height,
                margin: EdgeInsets.only(
                  bottom: defaultPadding,
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: height / 2,
                        top: 10,
                        bottom: 10,
                      ),
                      padding: EdgeInsets.only(
                        left: (height / 2) + (defaultPadding / 2),
                      ),
                      decoration: BoxDecoration(
                        color: awaitingApproval
                            ? secondaryYellow
                            : primaryLightBlue,
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName,
                              style: TextStyle(
                                color: textWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (awaitingApproval)
                            GestureDetector(
                              onTap: () =>
                                  viewModel.onMemberResponse(context, member),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2,
                                  vertical: defaultPadding / 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorderRadius,
                                  ),
                                  color: secondaryPaper,
                                ),
                                child: Text(
                                  "ver solicitação",
                                  style: TextStyle(
                                    color: secondaryYellow,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    SFAvatarUser(
                      height: height,
                      user: user,
                      showRank: false,
                      customBorderColor:
                          awaitingApproval ? secondaryYellow : primaryLightBlue,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
