import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/MatchMember.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import '../../../../Components/SFButton.dart';
import '../../../../StandardScreen/StandardScreenViewModel.dart';
import '../../../../Utils/Constants.dart';

class TeamMembersEditModal extends StatefulWidget {
  AppMatchUser match;
  Function(List<int>, List<int>) onUpdate;
  TeamMembersEditModal({
    required this.match,
    required this.onUpdate,
    super.key,
  });

  @override
  State<TeamMembersEditModal> createState() => _TeamMembersEditModalState();
}

class _TeamMembersEditModalState extends State<TeamMembersEditModal> {
  List<UserInMatch> usersInMatchRef = [];
  List<UserInMatch> usersInMatch = [];

  List<UserInMatch> get usersToRemove {
    List<UserInMatch> users = [];

    users = usersInMatchRef
        .where((userMatchRef) =>
            userMatchRef.inMatch &&
            !usersInMatch
                .firstWhere(
                    (userMatch) => userMatch.user.id == userMatchRef.user.id)
                .inMatch)
        .toList();

    return users;
  }

  List<UserInMatch> get usersToAdd {
    List<UserInMatch> users = [];

    users = usersInMatchRef
        .where((userMatchRef) =>
            !userMatchRef.inMatch &&
            usersInMatch
                .firstWhere(
                    (userMatch) => userMatch.user.id == userMatchRef.user.id)
                .inMatch)
        .toList();

    return users;
  }

  bool get hasChanged {
    return usersToAdd.isNotEmpty || usersToRemove.isNotEmpty;
  }

  List<UserInMatch> get sortedUsersInMatch {
    List<UserInMatch> users = usersInMatch;
    users.sort((a, b) {
      if (a.inMatch != b.inMatch) {
        return a.inMatch ? -1 : 1;
      }
      return a.user.firstName!.compareTo(b.user.firstName!);
    });
    return users;
  }

  @override
  void initState() {
    for (var teamMember in widget.match.team!.acceptedMembers) {
      usersInMatch.add(
        UserInMatch(
          user: teamMember.user,
          inMatch: widget.match.classMembers.any(
            (classMember) => classMember.user.id == teamMember.user.id,
          ),
        ),
      );
      usersInMatchRef = usersInMatch
          .map((userInMatch) => UserInMatch.copyWith(userInMatch))
          .toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      height: height * 0.8,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () =>
                  Provider.of<StandardScreenViewModel>(context, listen: false)
                      .removeLastOverlay(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: SvgPicture.asset(
                  r"assets/icon/x.svg",
                  color: textDarkGrey,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alunos presentes (${usersInMatch.where((userInMatch) => userInMatch.inMatch).length}):",
                  style: TextStyle(
                      color: textDarkGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: defaultPadding / 4,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      border: Border.all(
                        color: divider,
                      ),
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                    ),
                    padding: EdgeInsets.all(
                      defaultPadding / 2,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: sortedUsersInMatch.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: sortedUsersInMatch[index].inMatch
                                ? secondaryPaper
                                : secondaryBack,
                            borderRadius: BorderRadius.circular(
                              defaultBorderRadius,
                            ),
                            border: sortedUsersInMatch[index].inMatch
                                ? Border.all(
                                    color: divider,
                                  )
                                : null,
                          ),
                          margin: EdgeInsets.only(bottom: defaultPadding),
                          child: Row(
                            children: [
                              SFAvatarUser(
                                  height: 40,
                                  user: sortedUsersInMatch[index].user,
                                  showRank: false),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sortedUsersInMatch[index].user.fullName,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/${sortedUsersInMatch[index].inMatch ? 'check_circle' : 'x_circle'}.svg",
                                          height: 12,
                                          color:
                                              sortedUsersInMatch[index].inMatch
                                                  ? greenText
                                                  : redText,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text(
                                          sortedUsersInMatch[index].inMatch
                                              ? "Confirmado"
                                              : "Não confirmado",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: sortedUsersInMatch[index]
                                                    .inMatch
                                                ? greenText
                                                : redText,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  usersInMatch
                                          .firstWhere((userMatch) =>
                                              userMatch.user.id ==
                                              sortedUsersInMatch[index].user.id)
                                          .inMatch =
                                      !sortedUsersInMatch[index].inMatch;
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding / 2),
                                  child: SvgPicture.asset(
                                    "assets/icon/${sortedUsersInMatch[index].inMatch ? 'minus_circle' : 'plus_circle'}.svg",
                                    height: 20,
                                    color: sortedUsersInMatch[index].inMatch
                                        ? redText
                                        : primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SFButton(
            buttonLabel: "Salvar",
            color: hasChanged ? primaryBlue : disabled,
            onTap: () {
              if (hasChanged) {
                widget.onUpdate(
                  usersToAdd.map((user) => user.user.id!).toList(),
                  usersToRemove.map((user) => user.user.id!).toList(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class UserInMatch {
  UserStore user;
  bool inMatch;

  UserInMatch({
    required this.user,
    required this.inMatch,
  });
  factory UserInMatch.copyWith(UserInMatch refMatch) {
    return UserInMatch(inMatch: refMatch.inMatch, user: refMatch.user);
  }
}
