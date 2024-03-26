import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import 'User/User.dart';

class Teacher {
  int idTeacher;
  User user;
  bool waitingApproval;
  DateTime entryDate;

  Teacher({
    required this.idTeacher,
    required this.user,
    required this.waitingApproval,
    required this.entryDate,
  });

  factory Teacher.fromJson(
    Map<String, dynamic> json,
  ) {
    return Teacher(
      idTeacher: json["IdStoreSchoolTeacher"],
      waitingApproval: json["IdStoreSchoolTeacher"],
      entryDate: DateFormat("dd/MM/yyyy").parse(
        json["ResponseDate"],
      ),
      user: UserStore.fromUserMinJson(json["User"]),
    );
  }
}
