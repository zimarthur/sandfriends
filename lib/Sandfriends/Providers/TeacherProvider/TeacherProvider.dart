import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherUser.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/teacherRepo.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../Common/Enum/EnumClassFormat.dart';
import '../../../Common/Model/Classes/TeacherSchool/TeacherSchoolUser.dart';
import '../../../Common/Model/Team.dart';
import '../../../Common/Model/User/UserComplete.dart';
import '../../../Common/Providers/Environment/EnvironmentProvider.dart';

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

  late DateTime matchesStartDate;
  late DateTime matchesEndDate;
  final List<AppMatchUser> _matches = [];
  List<AppMatchUser> get matches {
    _matches.sort((a, b) {
      int compare = a.timeBegin.hour.compareTo(b.timeBegin.hour);

      if (compare == 0) {
        return a.court.store!.idStore.compareTo(b.court.store!.idStore);
      } else {
        return compare;
      }
    });
    return _matches;
  }

  List<AppMatchUser> get todayMatches {
    List<AppMatchUser> matchesForToday = matches
        .where((match) => areInTheSameDay(match.date, DateTime.now()))
        .toList();
    return matchesForToday;
  }

  late TeacherUser teacher;

  int get partnerSchools => teacher.teacherSchools
      .where((teacherSchool) => teacherSchool.waitingApproval == false)
      .toList()
      .length;
  int get awaitingResponseSchools => teacher.teacherSchools
      .where((teacherSchool) => teacherSchool.waitingApproval == true)
      .toList()
      .length;

  void getTeacherInfo(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    teacherRepo
        .getTeacherInfo(
            context,
            Provider.of<EnvironmentProvider>(context, listen: false)
                .accessToken!,
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

        final matches = responseBody['Matches'];
        _matches.clear();
        for (var match in matches) {
          _matches.add(
            AppMatchUser.fromJson(
              match,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
              Provider.of<CategoriesProvider>(context, listen: false).ranks,
              Provider.of<CategoriesProvider>(context, listen: false).genders,
            ),
          );
        }
        matchesStartDate =
            DateFormat("dd/MM/yyyy").parse(responseBody['MatchesStartDate']);
        matchesEndDate =
            DateFormat("dd/MM/yyyy").parse(responseBody['MatchesEndDate']);

        teacher = TeacherUser.fromJson(
          responseBody['Teacher'],
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
          Provider.of<CategoriesProvider>(context, listen: false).ranks,
          Provider.of<CategoriesProvider>(context, listen: false).genders,
        );
        notifyListeners();
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  //Class
  void addClassPlan(ClassPlan classPlan) {
    teacher.classPlans.add(classPlan);
    notifyListeners();
  }

  void editClassPlan(ClassPlan classPlan) {
    teacher.classPlans
        .firstWhere((plan) => plan.idClassPlan == classPlan.idClassPlan)
        .price = classPlan.price;
    notifyListeners();
  }

  void deleteClassPlan(ClassPlan classPlan) {
    teacher.classPlans.remove(classPlan);
    notifyListeners();
  }

  //Team
  void addTeam(Team team) {
    teacher.teams.add(team);
    notifyListeners();
  }

  //School
  void schoolTeacherResponse(
      TeacherSchoolUser newTeacherSchool, bool accepted) {
    if (accepted) {
      int index = teacher.teacherSchools.indexWhere((teacherSchool) =>
          teacherSchool.idTeacher == newTeacherSchool.idTeacher);
      teacher.teacherSchools[index] = newTeacherSchool;
    } else {
      teacher.teacherSchools.removeWhere(
          (school) => school.idTeacher == newTeacherSchool.idTeacher);
    }
    notifyListeners();
  }
}
