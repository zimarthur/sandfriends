import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/School/School.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Model/Teacher.dart';

class SchoolUser extends School {
  StoreUser store;

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
    List<Sport> referenceSports,
  ) {
    SchoolUser newSchool = SchoolUser(
      idSchool: json["IdStoreSchool"],
      name: json["Name"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      logo: json["Logo"],
      store: StoreUser.fromJson(
        json["Store"],
      ),
    );

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

    return school;
  }
}
