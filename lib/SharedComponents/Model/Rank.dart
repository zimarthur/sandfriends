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

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      idRankCategory: json['RankCategory']['IdRankCategory'],
      sport: Sport.fromJson(json['RankCategory']['Sport']),
      rankSportLevel: json['RankCategory']['RankSportLevel'],
      name: json['RankCategory']['RankName'],
      color: json['RankCategory']['RankColor'],
    );
  }
}
