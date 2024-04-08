import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Team.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import '../../Gender.dart';
import '../../Hour.dart';
import '../../Rank.dart';
import '../../Sport.dart';
import '../../User/User.dart';
import '../TeacherSchool/TeacherSchool.dart';

abstract class Teacher {
  UserStore user;
  List<Team> teams = [];

  Teacher({
    required this.user,
  });
}
