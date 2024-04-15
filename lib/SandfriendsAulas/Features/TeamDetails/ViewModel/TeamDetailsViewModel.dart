import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/ConfirmationModal.dart';
import 'package:sandfriends/Common/Model/TeamMember.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/Repo/TeamRepo.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsAbout.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsNextMatches.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Model/TabItem.dart';
import '../../../../Common/Model/Team.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Remote/NetworkResponse.dart';

class TeamDetailsViewModel extends StandardScreenViewModel {
  final teamRepo = TeamRepo();

  late Team team;
  bool isTeacherCreator = false;

  void initTeamDetailsViewModel(
    BuildContext context,
    Team teamArg,
  ) {
    team = teamArg;
    isTeacherCreator = team.teacher!.id ==
        Provider.of<UserProvider>(context, listen: false).user!.id;
    tabItems = [
      SFTabItem(
        name: "Sobre",
        displayWidget: TeamDetailsAbout(),
        onTap: (newTab) {
          setSelectedTab(newTab);
        },
      ),
      SFTabItem(
        name: "Próximas aulas",
        displayWidget: TeamDetailsNextMatches(),
        onTap: (newTab) {
          setSelectedTab(newTab);
        },
      ),
    ];
    setSelectedTab(tabItems.first);
    notifyListeners();
  }

  List<SFTabItem> tabItems = [];

  late SFTabItem _selectedTab;
  SFTabItem get selectedTab => _selectedTab;
  void setSelectedTab(SFTabItem newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }

  void joinTeam(
    BuildContext context,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    teamRepo
        .joinTeam(
      context,
      Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
      team,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        updateMembers(context, response);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Solicitação enviada",
            onTap: () {},
            isHappy: true,
          ),
        );
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  void updateMembers(
    BuildContext context,
    NetworkResponse response,
  ) {
    Map<String, dynamic> responseBody = json.decode(
      response.responseBody!,
    );

    final responseMembers = responseBody['Members'];
    List<TeamMember> teamMembers = [];
    for (var member in responseMembers) {
      teamMembers.add(
        TeamMember.fromJson(
          member,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
          Provider.of<CategoriesProvider>(context, listen: false).ranks,
          Provider.of<CategoriesProvider>(context, listen: false).genders,
        ),
      );
    }
    Provider.of<UserProvider>(context, listen: false)
        .updateTeamMembers(teamMembers, team);
    team.members = teamMembers;
    notifyListeners();
  }

  void onMemberResponse(BuildContext context, TeamMember member) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ConfirmationModal(
        message: "Deseja adicionar ${member.user.firstName} a turma?",
        onConfirm: () => sendMemberResponse(context, member, true),
        onCancel: () => sendMemberResponse(context, member, false),
        isHappy: true,
      ),
    );
  }

  void sendMemberResponse(
    BuildContext context,
    TeamMember member,
    bool accepted,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .clearOverlays();
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    teamRepo
        .sendMemberResponse(
      context,
      Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
      member,
      accepted,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        updateMembers(context, response);
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }
}
