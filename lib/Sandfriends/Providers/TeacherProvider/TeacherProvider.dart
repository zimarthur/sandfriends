import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/School/SchoolTeacher.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/teacherRepo.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../Common/Enum/EnumClassFormat.dart';
import '../../../Common/Model/Team.dart';

class TeacherProvider extends ChangeNotifier {
  final teacherRepo = TeacherRepo();

  final List<AppRecurrentMatchUser> _recurrentMatches = [];
  List<AppRecurrentMatchUser> get recurrentMatches {
    _recurrentMatches.sort((a, b) {
      int compare = a.timeBegin.hour.compareTo(b.timeBegin.hour);

      if (compare == 0) {
        return a.court.store!.idStore.compareTo(b.court.store!.idStore);
      } else {
        return compare;
      }
    });
    return _recurrentMatches;
  }

  final List<ClassPlan> _classPlans = [];
  List<ClassPlan> get classPlans {
    _classPlans.sort(
      (a, b) {
        int compare = a.format.value.compareTo(b.format.value);

        if (compare == 0) {
          return a.classFrequency.value.compareTo(b.classFrequency.value);
        } else {
          return compare;
        }
      },
    );
    return _classPlans;
  }

  final List<Team> _teams = [];
  List<Team> get teams => _teams;

  final List<SchoolTeacher> _schools = [];
  List<SchoolTeacher> get schools {
    _schools.sort(
      (a, b) {
        if (b.teacherInformation.waitingApproval) {
          return 1;
        } else {
          return -1;
        }
      },
    );

    return _schools;
  }

  int get partnerSchools => schools
      .where((school) => school.teacherInformation.waitingApproval == false)
      .toList()
      .length;
  int get awaitingResponseSchools => schools
      .where((school) => school.teacherInformation.waitingApproval == true)
      .toList()
      .length;

  void getTeacherInfo(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    teacherRepo
        .getTeacherInfo(
            context,
            Provider.of<UserProvider>(context, listen: false).user!.accessToken,
            null)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        final recurrentMatches = responseBody['RecurrentMatches'];
        _recurrentMatches.clear();
        for (var recurrentMatch in recurrentMatches) {
          _recurrentMatches.add(
            AppRecurrentMatchUser.fromJson(
              recurrentMatch,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
              Provider.of<CategoriesProvider>(context, listen: false).ranks,
              Provider.of<CategoriesProvider>(context, listen: false).genders,
            ),
          );
        }

        final teacherPlans = responseBody['TeacherPlans'];
        _classPlans.clear();
        for (var teacherPlan in teacherPlans) {
          _classPlans.add(
            ClassPlan.fromJson(
              teacherPlan,
            ),
          );
        }

        final teams = responseBody['Teams'];
        _teams.clear();
        for (var team in teams) {
          _teams.add(
            Team.fromJson(
              team,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
              Provider.of<CategoriesProvider>(context, listen: false).ranks,
              Provider.of<CategoriesProvider>(context, listen: false).genders,
            ),
          );
        }

        final schools = responseBody['Schools'];
        _schools.clear();
        for (var school in schools) {
          _schools.add(
            SchoolTeacher.fromJson(
              school,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }
        notifyListeners();
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  //Class
  void addClassPlan(ClassPlan classPlan) {
    _classPlans.add(classPlan);
    notifyListeners();
  }

  void editClassPlan(ClassPlan classPlan) {
    _classPlans
        .firstWhere((plan) => plan.idClassPlan == classPlan.idClassPlan)
        .price = classPlan.price;
    notifyListeners();
  }

  void deleteClassPlan(ClassPlan classPlan) {
    _classPlans.remove(classPlan);
    notifyListeners();
  }

  //Team
  void addTeam(Team team) {
    _teams.add(team);
    notifyListeners();
  }

  //School
  void schoolTeacherResponse(SchoolTeacher schoolTeacher, bool accepted) {
    if (accepted) {
      _schools
          .firstWhere((school) =>
              school.teacherInformation.idTeacher ==
              schoolTeacher.teacherInformation.idTeacher)
          .teacherInformation = schoolTeacher.teacherInformation;
    } else {
      _schools.removeWhere((school) =>
          school.teacherInformation.idTeacher ==
          schoolTeacher.teacherInformation.idTeacher);
    }
    notifyListeners();
  }
}
