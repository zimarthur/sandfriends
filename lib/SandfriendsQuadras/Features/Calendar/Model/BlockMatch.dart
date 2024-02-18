import 'package:sandfriends/Common/Model/User/UserStore.dart';
import '../../../../Common/Model/Hour.dart';

class BlockMatch {
  bool isRecurrent;
  int idStoreCourt;
  Hour timeBegin;
  UserStore player;
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
