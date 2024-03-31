import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/School/School.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';

class SchoolTeacher extends School {
  Teacher teacherInformation;

  SchoolTeacher({
    required super.idSchool,
    required super.name,
    required super.creationDate,
    required super.sport,
    required super.logo,
    required this.teacherInformation,
  });

  factory SchoolTeacher.fromJson(
    Map<String, dynamic> json,
    List<Sport> referenceSports,
  ) {
    Map<String, dynamic> schoolJson = json["StoreSchool"];
    SchoolTeacher newSchool = SchoolTeacher(
      idSchool: schoolJson["IdStoreSchool"],
      name: schoolJson["Name"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        schoolJson["CreationDate"],
      ),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == schoolJson["IdSport"]),
      logo: schoolJson["Logo"],
      teacherInformation: Teacher.fromJson(json),
    );

    return newSchool;
  }

  factory SchoolTeacher.copyFrom(SchoolTeacher refSchool) {
    final school = SchoolTeacher(
      idSchool: refSchool.idSchool,
      name: refSchool.name,
      sport: refSchool.sport,
      creationDate: refSchool.creationDate,
      logo: refSchool.logo,
      teacherInformation: refSchool.teacherInformation,
    );

    return school;
  }
}
