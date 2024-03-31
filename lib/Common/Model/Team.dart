import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Model/Gender.dart';
import 'package:sandfriends/Common/Model/Rank.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import 'Hour.dart';
import 'TeamMember.dart';

class Team {
  int? idTeam;
  User teacher;
  String name;
  String description;
  DateTime creationDate;
  Sport sport;
  Gender gender;
  Rank? rank;

  List<TeamMember> members = [];
  List<AppRecurrentMatchUser> recurrentMatches = [];

  List<TeamMember> get membersAndPendinds {
    List<TeamMember> filteredMembers =
        members.where((member) => member.refused == false).toList();
    filteredMembers.sort((a, b) {
      if (b.waitingApproval) {
        return 1;
      } else {
        return -1;
      }
    });
    return filteredMembers;
  }

  List<TeamMember> get acceptedMembers => members
      .where((member) =>
          member.refused == false && member.waitingApproval == false)
      .toList();

  bool isUserInTeam(User user) {
    return members.any(
      (member) => member.user.id == user.id && member.refused == false,
    );
  }

  bool hasUserSentInvitation(User user) {
    return members.any(
      (member) =>
          member.user.id == user.id &&
          member.refused == false &&
          member.waitingApproval == true,
    );
  }

  Team({
    required this.idTeam,
    required this.teacher,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.sport,
    required this.gender,
    required this.rank,
  });

  factory Team.fromJson(
    Map<String, dynamic> json,
    List<Hour> hours,
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    Team newTeam = Team(
      idTeam: json["IdTeam"],
      name: json["Name"],
      description: json["Description"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      teacher: UserComplete.fromJson(json["User"]),
      gender: genders.firstWhere(
        (gender) => gender.idGender == json["IdGenderCategory"],
      ),
      rank: ranks.firstWhere(
        (rank) => rank.idRankCategory == json["IdRankCategory"],
      ),
      sport: sports.firstWhere(
        (sport) => sport.idSport == json["IdSport"],
      ),
    );
    if (json["Members"] != null) {
      for (var member in json["Members"]) {
        newTeam.members.add(
          TeamMember.fromJson(
            member,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    if (json["RecurrentMatches"] != null) {
      for (var recMatch in json["RecurrentMatches"]) {
        newTeam.recurrentMatches.add(
          AppRecurrentMatchUser.fromJson(
            recMatch,
            hours,
            sports,
            ranks,
            genders,
          ),
        );
      }
    }
    return newTeam;
  }

  factory Team.copyFrom(Team refTeam) {
    return Team(
      idTeam: refTeam.idTeam,
      name: refTeam.name,
      description: refTeam.description,
      teacher: refTeam.teacher,
      creationDate: refTeam.creationDate,
      rank: refTeam.rank,
      gender: refTeam.gender,
      sport: refTeam.sport,
    );
  }
}
