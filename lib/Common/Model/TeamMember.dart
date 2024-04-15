import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/Gender.dart';
import 'package:sandfriends/Common/Model/Rank.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

class TeamMember {
  int idTeamMember;
  UserStore user;
  bool waitingApproval;
  bool refused;
  DateTime requestDate;
  DateTime? responseDate;

  TeamMember({
    required this.idTeamMember,
    required this.user,
    required this.waitingApproval,
    required this.refused,
    required this.requestDate,
    required this.responseDate,
  });

  factory TeamMember.fromJson(
    Map<String, dynamic> json,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    return TeamMember(
      idTeamMember: json["IdTeamMember"],
      waitingApproval: json["WaitingApproval"],
      refused: json["Refused"],
      requestDate: DateFormat("dd/MM/yyyy").parse(
        json["RequestDate"],
      ),
      responseDate: json["ResponseDate"] != null
          ? DateFormat("dd/MM/yyyy").parse(
              json["ResponseDate"],
            )
          : null,
      user: UserStore.fromUserJson(
        json["User"],
        sports,
        genders,
        ranks,
      ),
    );
  }

  factory TeamMember.copyFrom(TeamMember refTeam) {
    return TeamMember(
      idTeamMember: refTeam.idTeamMember,
      user: refTeam.user,
      waitingApproval: refTeam.waitingApproval,
      refused: refTeam.refused,
      requestDate: refTeam.requestDate,
      responseDate: refTeam.responseDate,
    );
  }
}
