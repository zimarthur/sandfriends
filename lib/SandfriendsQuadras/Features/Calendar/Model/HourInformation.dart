import '../../../../Common/Model/AppMatch.dart';
import '../../../../Common/Model/AppRecurrentMatch.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Sport.dart';

class HourInformation {
  bool match;
  bool recurrentMatch;
  bool freeHour;
  String creatorName;
  Sport? sport;
  double? cost;
  bool? payInStore;
  Hour timeBegin;
  Hour timeEnd;
  Court court;

  AppMatch? refMatch;
  AppRecurrentMatch? refRecurrentMatch;

  HourInformation({
    this.match = false,
    this.recurrentMatch = false,
    this.freeHour = false,
    required this.creatorName,
    this.sport,
    this.payInStore,
    this.cost,
    required this.court,
    required this.timeBegin,
    required this.timeEnd,
    this.refMatch,
    this.refRecurrentMatch,
  });
}
