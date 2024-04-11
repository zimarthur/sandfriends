import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherStore.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherUser.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';

class SchoolUser extends School {
  StoreUser store;
  List<TeacherStore> teachers = [];

  SchoolUser({
    required super.idSchool,
    required super.name,
    required super.creationDate,
    required super.sport,
    required super.logo,
    required this.store,
  });

  factory SchoolUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    SchoolUser newSchool = SchoolUser(
      idSchool: json["IdStoreSchool"],
      name: json["Name"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      sport: sports.firstWhere((sport) => sport.idSport == json["IdSport"]),
      logo: json["Logo"],
      store: StoreUser.fromJson(
        json["Store"],
      ),
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

  factory SchoolUser.copyFrom(SchoolUser refSchool) {
    final school = SchoolUser(
      idSchool: refSchool.idSchool,
      name: refSchool.name,
      sport: refSchool.sport,
      creationDate: refSchool.creationDate,
      logo: refSchool.logo,
      store: refSchool.store,
    );
    school.teachers = refSchool.teachers;
    return school;
  }
}
