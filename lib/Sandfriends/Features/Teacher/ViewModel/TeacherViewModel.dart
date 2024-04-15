import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

class TeacherViewModel extends StandardScreenViewModel {
  late Teacher teacher;
  void initTeacherViewModel(
    BuildContext context,
    Teacher teacherArg,
  ) {
    teacher = teacherArg;
    notifyListeners();
  }
}
