import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Player.dart';

class BlockMatch {
  bool isRecurrent;
  int idStoreCourt;
  Hour timeBegin;
  Player player;
  String observation;
  int idSport;
  double price;

  BlockMatch({
    required this.isRecurrent,
    required this.idStoreCourt,
    required this.timeBegin,
    required this.player,
    required this.observation,
    required this.idSport,
    required this.price,
  });
}
