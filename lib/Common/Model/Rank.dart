import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import 'Sport.dart';

class Rank {
  final int idRankCategory;
  final Sport sport;
  final int rankSportLevel;
  final String name;
  final String color;

  Rank({
    required this.idRankCategory,
    required this.sport,
    required this.rankSportLevel,
    required this.name,
    required this.color,
  });

  bool get isNeutralRank => rankSportLevel == 0;

  Color get colorObj => name == "-"
      ? textDarkGrey
      : Color(int.parse("0xFF${color.replaceAll("#", "")}"));

  factory Rank.fromJson(Map<String, dynamic> json,
      {List<Sport>? availableSports}) {
    return Rank(
      idRankCategory: json['IdRankCategory'],
      sport: availableSports != null
          ? availableSports
              .firstWhere((sport) => sport.idSport == json["IdSport"])
          : Sport.fromJson(json['Sport']),
      rankSportLevel: json['RankSportLevel'],
      name: json['RankName'],
      color: json['RankColor'],
    );
  }

  factory Rank.copyWith(Rank refRank) {
    return Rank(
      idRankCategory: refRank.idRankCategory,
      sport: refRank.sport,
      rankSportLevel: refRank.rankSportLevel,
      name: refRank.name,
      color: refRank.color,
    );
  }
}
