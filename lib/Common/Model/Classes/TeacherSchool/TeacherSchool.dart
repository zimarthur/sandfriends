import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';

import '../../Store/StoreUser.dart';

abstract class TeacherSchool {
  int idTeacher;
  bool waitingApproval;
  DateTime? entryDate;
  //Sport sport;

  TeacherSchool({
    required this.idTeacher,
    required this.waitingApproval,
    required this.entryDate,
    //required this.sport,
  });
}
