import 'sport.dart';

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
}

Rank rankFromJson(Map<String, dynamic> json) {
  var newRank = Rank(
    idRankCategory: json['RankCategory']['IdRankCategory'],
    sport: sportFromJson(json['RankCategory']['Sport']),
    rankSportLevel: json['RankCategory']['RankSportLevel'],
    name: json['RankCategory']['RankName'],
    color: json['RankCategory']['RankColor'],
  );
  return newRank;
}
