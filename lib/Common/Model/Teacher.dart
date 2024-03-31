import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import 'User/User.dart';

class Teacher {
  int idTeacher;
  UserStore user;
  bool waitingApproval;
  DateTime? entryDate;

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
      waitingApproval: json["WaitingApproval"],
      entryDate: json["ResponseDate"] != null
          ? DateFormat("dd/MM/yyyy").parse(
              json["ResponseDate"],
            )
          : null,
      user: UserStore.fromUserMinJson(json["User"]),
    );
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
