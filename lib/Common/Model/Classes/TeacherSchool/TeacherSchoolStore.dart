import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Store/StoreUser.dart';
import 'TeacherSchoolUser.dart';

class TeacherSchoolStore extends TeacherSchool {
  TeacherSchoolStore({
    required super.idTeacher,
    required super.waitingApproval,
    required super.entryDate,
  });

  factory TeacherSchoolStore.fromJson(
    Map<String, dynamic> json,
  ) {
    TeacherSchoolStore newSchool = TeacherSchoolStore(
      idTeacher: json["IdStoreSchoolTeacher"],
      waitingApproval: json["WaitingApproval"],
      entryDate: json["ResponseDate"] != null
          ? DateFormat("dd/MM/yyyy").parse(
              json["ResponseDate"],
            )
          : null,
    );

    return newSchool;
  }

  factory TeacherSchoolStore.copyFrom(TeacherSchoolStore refSchool) {
    final school = TeacherSchoolStore(
      idTeacher: refSchool.idTeacher,
      waitingApproval: refSchool.waitingApproval,
      entryDate: refSchool.entryDate,
    );

    return school;
  }

  factory TeacherSchoolStore.fromTeacherSchoolUser(
      TeacherSchoolUser refTeacherSchool) {
    final school = TeacherSchoolStore(
      idTeacher: refTeacherSchool.idTeacher,
      waitingApproval: refTeacherSchool.waitingApproval,
      entryDate: refTeacherSchool.entryDate,
    );

    return school;
  }
}
