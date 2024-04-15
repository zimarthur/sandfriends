import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchoolStore.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';
import '../../Sport.dart';
import '../../User/User.dart';
import '../TeacherSchool/TeacherSchool.dart';

class TeacherStore extends Teacher {
  TeacherSchoolStore teacherSchool;

  TeacherStore({
    required super.user,
    required this.teacherSchool,
  });

  factory TeacherStore.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    TeacherStore newTeacher = TeacherStore(
      user: UserStore.fromUserMinJson(json["User"]),
      teacherSchool: TeacherSchoolStore.fromJson(
        json,
      ),
    );
    if (json["Teams"] != null) {
      for (var team in json["Teams"]) {
        newTeacher.teams.add(
          Team.fromJson(
            team,
            hours,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    return newTeacher;
  }

  factory TeacherStore.copyFrom(TeacherStore refTeacher) {
    return TeacherStore(
      user: UserStore.copyFrom(refTeacher.user),
      teacherSchool: refTeacher.teacherSchool,
    );
  }
}
