import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/Gender.dart';
import 'package:sandfriends/Common/Model/Rank.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

class Team {
  int? idTeam;
  User teacher;
  String name;
  String description;
  DateTime creationDate;
  Sport sport;
  Gender gender;
  Rank? rank;

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
    List<Sport> sports,
    List<Rank> ranks,
    List<Gender> genders,
  ) {
    return Team(
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
