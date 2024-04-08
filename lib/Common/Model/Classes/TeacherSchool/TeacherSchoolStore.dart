import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Store/StoreUser.dart';

class TeacherSchoolStore extends TeacherSchool {
  TeacherSchoolStore({
    required super.idTeacher,
    required super.waitingApproval,
    required super.entryDate,
  });

  factory TeacherSchoolStore.fromJson(
    Map<String, dynamic> json,
  ) {
    Map<String, dynamic> schoolJson = json["StoreSchool"];
    TeacherSchoolStore newSchool = TeacherSchoolStore(
      idTeacher: schoolJson["IdStoreSchool"],
      waitingApproval: schoolJson["Name"],
      entryDate: DateFormat("dd/MM/yyyy").parse(
        schoolJson["CreationDate"],
      ),
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
}
