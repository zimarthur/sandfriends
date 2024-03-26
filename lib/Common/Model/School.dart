import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';

class School {
  int idSchool;
  String name;
  DateTime creationDate;
  Sport sport;
  String? logo;

  List<Teacher> teachers = [];

  School({
    required this.idSchool,
    required this.name,
    required this.creationDate,
    required this.sport,
    required this.logo,
  });

  factory School.fromJson(
    Map<String, dynamic> json,
    List<Sport> referenceSports,
  ) {
    School newSchool = School(
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
}
