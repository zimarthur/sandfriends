import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherStore.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherUser.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../../Common/Model/Classes/School/SchoolStore.dart';
import '../../../../../../Common/Model/Classes/School/SchoolUser.dart';
import '../../../../../../Common/Model/Classes/TeacherSchool/TeacherSchoolStore.dart';
import '../../../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../../../Remote/NetworkResponse.dart';
import '../Repo/ClassesRepo.dart';

class ClassesViewModel extends ChangeNotifier {
  final classesRepo = ClassesRepo();

  void initClassesViewModel(BuildContext context) {
    if (Provider.of<UserProvider>(context, listen: false).needsToLoadClasses) {
      getClassesInfo(context);
    }
  }

  void getClassesInfo(BuildContext context) {
    if (!Provider.of<UserProvider>(context, listen: false).needsToLoadClasses) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    }
    classesRepo
        .getClassesInfo(
      context,
      Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      List<SchoolUser> schools = [];
      List<TeacherUser> teachers = [];
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        for (var teacher in responseBody["Teachers"]) {
          teachers.add(
            TeacherUser.fromJson(
              teacher,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
              Provider.of<CategoriesProvider>(context, listen: false).ranks,
              Provider.of<CategoriesProvider>(context, listen: false).genders,
            ),
          );
        }

        for (var school in responseBody["Schools"]) {
          SchoolUser newSchool = SchoolUser.fromJson(
            school,
            Provider.of<CategoriesProvider>(context, listen: false).hours,
            Provider.of<CategoriesProvider>(context, listen: false).sports,
            Provider.of<CategoriesProvider>(context, listen: false).ranks,
            Provider.of<CategoriesProvider>(context, listen: false).genders,
          );
          for (var teacher in teachers) {
            if (teacher.teacherSchools.any((teacherSchool) =>
                teacherSchool.school.idSchool == newSchool.idSchool)) {
              TeacherSchoolStore teacherSchool =
                  TeacherSchoolStore.fromTeacherSchoolUser(
                teacher.teacherSchools.firstWhere((teacherSchool) =>
                    teacherSchool.school.idSchool == newSchool.idSchool),
              );
              TeacherStore teacherStore = TeacherStore(
                user: teacher.user,
                teacherSchool: teacherSchool,
              );
              teacherStore.teams = teacher.teams;
              newSchool.teachers.add(teacherStore);
            }
          }
          schools.add(
            newSchool,
          );
        }

        Provider.of<UserProvider>(context, listen: false)
            .setAvailableTeachers(teachers);
        Provider.of<UserProvider>(context, listen: false)
            .setAvailableSchools(schools);
      }
    });
  }
}
