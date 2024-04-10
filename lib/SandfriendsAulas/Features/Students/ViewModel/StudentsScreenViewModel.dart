import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchStore.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/TeamPaymentForUser.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';
import 'package:collection/collection.dart';

import '../../../../Common/Model/Team.dart';

class StudentsScreenAulasViewModel extends MenuProviderAulas {
  List<UserClassPayment> _classPaymentUsers = [];
  List<UserClassPayment> get filteredClassPaymentUsers {
    if (studentNameFilter.isEmpty) {
      return _classPaymentUsers;
    }
    List<UserClassPayment> filteredPaymentUsers = _classPaymentUsers;
    return filteredPaymentUsers
        .where((filteredPaymentUser) => filteredPaymentUser.user.fullName
            .toLowerCase()
            .contains(studentNameFilter.toLowerCase()))
        .toList();
  }

  void initStudentsViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Students,
    );
    Provider.of<TeacherProvider>(context, listen: false)
        .matches
        .forEach((match) {
      if (match.team != null) {
        for (var member in match.classMembers) {
          UserClassPayment? foundUserClassPayment =
              _classPaymentUsers.firstWhereOrNull((classPaymentUser) =>
                  classPaymentUser.user.id == member.user.id);
          List<ClassPlan> equivalentPlans =
              Provider.of<TeacherProvider>(context, listen: false)
                  .teacher
                  .classPlans
                  .where(
                    (classPlan) =>
                        classPlan.format ==
                        classFormatFromInt(
                          match.team!.acceptedMembers.length,
                        ),
                  )
                  .toList();
          AppMatchUser matchWithMemberSelection = AppMatchUser.copyWith(match);
          matchWithMemberSelection.selectedMember = member;
          if (foundUserClassPayment == null) {
            UserClassPayment newUser = UserClassPayment(
              user: UserStore.fromUserComplete(member.user),
            );
            TeamPaymentForUser newTeamPaymentForUser = TeamPaymentForUser(
              team: Provider.of<TeacherProvider>(context, listen: false)
                  .teacher
                  .teams
                  .firstWhere(
                    (team) => team.idTeam == match.team!.idTeam,
                  ),
              teamClassPlan: equivalentPlans,
            );
            newTeamPaymentForUser.teamMatches.add(matchWithMemberSelection);
            newUser.teamPayments.add(newTeamPaymentForUser);
            _classPaymentUsers.add(newUser);
          } else {
            TeamPaymentForUser? foundTeamPayment = foundUserClassPayment
                .teamPayments
                .firstWhereOrNull((teamPayments) =>
                    teamPayments.team.idTeam == match.team!.idTeam);
            if (foundTeamPayment == null) {
              TeamPaymentForUser newTeamPaymentForUser = TeamPaymentForUser(
                team: match.team!,
                teamClassPlan: equivalentPlans,
              );
              newTeamPaymentForUser.teamMatches.add(matchWithMemberSelection);
              foundUserClassPayment.teamPayments.add(
                newTeamPaymentForUser,
              );
            } else {
              foundTeamPayment.teamMatches.add(matchWithMemberSelection);
            }
          }
        }
      }
    });

    notifyListeners();
  }

  TextEditingController nameFilterController = TextEditingController();
  String studentNameFilter = "";
  void filterName(BuildContext context) {
    studentNameFilter = nameFilterController.text;
    notifyListeners();
  }
}
