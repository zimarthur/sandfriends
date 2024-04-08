import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';
import '../../Store/StoreUser.dart';

class TeacherSchoolUser extends TeacherSchool {
  SchoolUser school;

  TeacherSchoolUser({
    required super.idTeacher,
    required super.waitingApproval,
    required super.entryDate,
    required this.school,
  });

  factory TeacherSchoolUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    Map<String, dynamic> schoolJson = json["StoreSchool"];
    TeacherSchoolUser newSchool = TeacherSchoolUser(
      idTeacher: json["IdStoreSchoolTeacher"],
      waitingApproval: json["WaitingApproval"],
      entryDate: DateFormat("dd/MM/yyyy").parse(
        json["ResponseDate"],
      ),
      school: SchoolUser.fromJson(
        schoolJson,
        hours,
        sports,
        ranks,
        genders,
      ),
    );

    return newSchool;
  }

  factory TeacherSchoolUser.copyFrom(TeacherSchoolUser refSchool) {
    final school = TeacherSchoolUser(
      idTeacher: refSchool.idTeacher,
      waitingApproval: refSchool.waitingApproval,
      entryDate: refSchool.entryDate,
      school: refSchool.school,
    );

    return school;
  }
}
