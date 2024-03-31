import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import 'Gender.dart';
import 'Hour.dart';
import 'Rank.dart';
import 'Sport.dart';
import 'User/User.dart';

class Teacher {
  int idTeacher;
  UserStore user;
  bool waitingApproval;
  DateTime? entryDate;

  List<Team> teams = [];

  Teacher({
    required this.idTeacher,
    required this.user,
    required this.waitingApproval,
    required this.entryDate,
  });

  factory Teacher.fromJson(
    Map<String, dynamic> json,
  ) {
    Teacher newTeacher = Teacher(
      idTeacher: json["IdStoreSchoolTeacher"],
      waitingApproval: json["WaitingApproval"],
      entryDate: json["ResponseDate"] != null
          ? DateFormat("dd/MM/yyyy").parse(
              json["ResponseDate"],
            )
          : null,
      user: UserStore.fromUserMinJson(json["User"]),
    );
    return newTeacher;
  }
  factory Teacher.fromJsonUser(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    Teacher newTeacher = Teacher(
      idTeacher: json["IdStoreSchoolTeacher"],
      waitingApproval: json["WaitingApproval"],
      entryDate: json["ResponseDate"] != null
          ? DateFormat("dd/MM/yyyy").parse(
              json["ResponseDate"],
            )
          : null,
      user: UserStore.fromUserMinJson(json["User"]),
    );
    if (json["Teams"] != null) {
      for (var team in json["Teams"]) {
        newTeacher.teams.add(
          Team.fromJson(
            team,
            hours,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    return newTeacher;
  }

  factory Teacher.copyFrom(Teacher refTeacher) {
    return Teacher(
      idTeacher: refTeacher.idTeacher,
      user: UserStore.copyFrom(refTeacher.user),
      waitingApproval: refTeacher.waitingApproval,
      entryDate: refTeacher.entryDate,
    );
  }
}
