import '../AppMatch/AppMatch.dart';
import '../Court.dart';
import '../Hour.dart';
import '../Sport.dart';

abstract class AppRecurrentMatch {
  final int idRecurrentMatch;
  final DateTime creationDate;
  final DateTime lastPaymentDate;
  final DateTime validUntil;
  final int weekday;
  final Hour timeBegin;
  final Hour timeEnd;
  final Sport sport;
  final Court court;
  final int matchCounter;

  List<AppMatch> get nextRecurrentMatches;

  AppRecurrentMatch({
    required this.idRecurrentMatch,
    required this.creationDate,
    required this.lastPaymentDate,
    required this.validUntil,
    required this.weekday,
    required this.timeBegin,
    required this.timeEnd,
    required this.sport,
    required this.court,
    required this.matchCounter,
  });

  int get recurrentMatchDuration {
    return timeEnd.hour - timeBegin.hour;
  }

  String get matchHourDescription =>
      "${timeBegin.hourString} - ${timeEnd.hourString}";

  double get currentMonthPrice => nextRecurrentMatches.fold(
      0, (previousValue, element) => previousValue + element.cost);

  double get matchCost => currentMonthPrice / nextRecurrentMatches.length;

  bool get isPaymentExpired {
    return DateTime.now().isAfter(validUntil);
  }
}
