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
