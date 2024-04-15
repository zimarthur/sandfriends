import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

abstract class School {
  int idSchool;
  String name;
  DateTime creationDate;
  Sport sport;
  String? logo;

  School({
    required this.idSchool,
    required this.name,
    required this.creationDate,
    required this.sport,
    required this.logo,
  });
}
