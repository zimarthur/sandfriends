import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/School/School.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';

class SchoolStore extends School {
  List<Teacher> teachers = [];

  SchoolStore({
    required super.idSchool,
    required super.name,
    required super.creationDate,
    required super.sport,
    required super.logo,
  });

  factory SchoolStore.fromJson(
    Map<String, dynamic> json,
    List<Sport> referenceSports,
  ) {
    SchoolStore newSchool = SchoolStore(
      idSchool: json["IdStoreSchool"],
      name: json["Name"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      logo: json["Logo"],
    );
    if (json['StoreSchoolTeachers'] != null) {
      for (var teacher in json['StoreSchoolTeachers']) {
        newSchool.teachers.add(
          Teacher.fromJson(
            teacher,
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
        Teacher.copyFrom(
          teacher,
        ),
      );
    }

    return school;
  }
}
