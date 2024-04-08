import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import '../../ClassPlan.dart';
import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';
import '../../Sport.dart';
import '../../User/User.dart';
import '../TeacherSchool/TeacherSchool.dart';
import '../TeacherSchool/TeacherSchoolUser.dart';

class TeacherUser extends Teacher {
  final List<TeacherSchoolUser> teacherSchools = [];
  List<TeacherSchoolUser> get sortedTeacherSchools {
    teacherSchools.sort(
      (a, b) {
        if (b.waitingApproval) {
          return 1;
        } else {
          return -1;
        }
      },
    );

    return teacherSchools;
  }

  final List<ClassPlan> classPlans = [];
  List<ClassPlan> get sortedClassPlans {
    classPlans.sort(
      (a, b) {
        int compare = a.format.value.compareTo(b.format.value);

        if (compare == 0) {
          return a.classFrequency.value.compareTo(b.classFrequency.value);
        } else {
          return compare;
        }
      },
    );
    return classPlans;
  }

  bool get hasSetMinClassPlans {
    int avulsoCounter = 0;
    for (var plan in classPlans) {
      if (plan.classFrequency == EnumClassFrequency.None) {
        avulsoCounter++;
      }
    }
    return avulsoCounter >= 3;
  }

  TeacherUser({
    required super.user,
  });

  factory TeacherUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    TeacherUser newTeacher = TeacherUser(
      user: UserStore.fromUserMinJson(json),
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
            refTeacher: newTeacher.user,
          ),
        );
      }
    }
    if (json["TeacherSchools"] != null) {
      for (var teacherSchool in json["TeacherSchools"]) {
        newTeacher.teacherSchools.add(
          TeacherSchoolUser.fromJson(
            teacherSchool,
            hours,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    if (json["TeacherPlans"] != null) {
      for (var classPlan in json["TeacherPlans"]) {
        newTeacher.classPlans.add(
          ClassPlan.fromJson(
            classPlan,
          ),
        );
      }
    }
    return newTeacher;
  }

  factory TeacherUser.copyFrom(TeacherUser refTeacher) {
    return TeacherUser(
      user: UserStore.copyFrom(refTeacher.user),
    );
  }
}
