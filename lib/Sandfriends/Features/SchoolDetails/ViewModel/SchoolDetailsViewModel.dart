import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherStore.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherUser.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

class SchoolDetailsViewModel extends StandardScreenViewModel {
  late SchoolUser school;
  List<TeacherStore> teachers = [];

  void initSchoolDetailsViewModel(BuildContext context, SchoolUser schoolArg) {
    school = schoolArg;
    if (Provider.of<UserProvider>(context, listen: false).availableTeachers !=
        null) {
      for (var teacher in Provider.of<UserProvider>(context, listen: false)
          .availableTeachers!) {
        if (teacher.teacherSchools.any((teacherSchool) =>
            teacherSchool.school.idSchool == school.idSchool)) {
          TeacherUser newTeacher = TeacherUser(user: teacher.user);
        }
      }
    }
    notifyListeners();
  }
}
