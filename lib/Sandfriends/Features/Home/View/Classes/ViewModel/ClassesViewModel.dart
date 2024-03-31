import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/School/SchoolTeacher.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../../Common/Model/School/SchoolStore.dart';
import '../../../../../../Common/Model/School/SchoolUser.dart';
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
        .getClassesInfo(context,
            Provider.of<UserProvider>(context, listen: false).user!.accessToken)
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      List<Teacher> teachers = [];
      List<SchoolUser> schools = [];
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        for (var teacher in responseBody["Teachers"]) {
          teachers.add(
            Teacher.fromJson(
              teacher,
            ),
          );
        }
        for (var school in responseBody["Schools"]) {
          schools.add(
            SchoolUser.fromJson(
              school,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }
      }
      Provider.of<UserProvider>(context, listen: false)
          .setAvailableTeachers(teachers);
      Provider.of<UserProvider>(context, listen: false)
          .setAvailableSchools(schools);
    });
  }
}
