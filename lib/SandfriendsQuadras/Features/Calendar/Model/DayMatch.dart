import '../../../../Common/Model/AppMatch.dart';
import '../../../../Common/Model/AppRecurrentMatch.dart';
import '../../../../Common/Model/Hour.dart';

class DayMatch {
  Hour startingHour;
  AppMatch? match;
  List<AppMatch>? matches;
  AppRecurrentMatch? recurrentMatch;
  List<AppRecurrentMatch>? recurrentMatches;
  bool operationHour;

  DayMatch({
    required this.startingHour,
    this.match,
    this.matches,
    this.recurrentMatch,
    this.recurrentMatches,
    this.operationHour = false,
  });

  int matchesLengthConsideringRecurrent() {
    int total = 0;
    if (matches != null) {
      total += matches!.where((match) => match.canceled == false).length;
    }
    if (recurrentMatches != null) {
      for (var recMatch in recurrentMatches!) {
        if (matches?.any((match) =>
                match.idRecurrentMatch == recMatch.idRecurrentMatch) ==
            false) {
          total += 1;
        }
      }
    }
    return total;
  }

  factory DayMatch.copyWith(DayMatch refDayMatch) {
    return DayMatch(
      startingHour: refDayMatch.startingHour,
      match: refDayMatch.match,
      matches: refDayMatch.matches,
      recurrentMatch: refDayMatch.recurrentMatch,
      recurrentMatches: refDayMatch.recurrentMatches,
      operationHour: refDayMatch.operationHour,
    );
  }
}
