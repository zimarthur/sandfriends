import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';
import '../Teacher/TeacherStore.dart';

class SchoolStore extends School {
  List<TeacherStore> teachers = [];

  SchoolStore({
    required super.idSchool,
    required super.name,
    required super.creationDate,
    required super.sport,
    required super.logo,
  });

  factory SchoolStore.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    SchoolStore newSchool = SchoolStore(
      idSchool: json["IdStoreSchool"],
      name: json["Name"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      sport: sports.firstWhere((sport) => sport.idSport == json["IdSport"]),
      logo: json["Logo"],
    );
    if (json['StoreSchoolTeachers'] != null) {
      for (var teacher in json['StoreSchoolTeachers']) {
        newSchool.teachers.add(
          TeacherStore.fromJson(
            teacher,
            hours,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    return newSchool;
  }

  factory SchoolStore.copyFrom(SchoolStore refSchool) {
    final school = SchoolStore(
      idSchool: refSchool.idSchool,
      name: refSchool.name,
      sport: refSchool.sport,
      creationDate: refSchool.creationDate,
      logo: refSchool.logo,
    );
    for (var teacher in refSchool.teachers) {
      school.teachers.add(
        TeacherStore.copyFrom(
          teacher,
        ),
      );
    }

    return school;
  }
}
