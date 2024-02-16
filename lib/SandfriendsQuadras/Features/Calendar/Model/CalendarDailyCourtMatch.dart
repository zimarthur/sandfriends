import '../../../../Common/Model/Court.dart';
import 'DayMatch.dart';

class CalendarDailyCourtMatch {
  Court court;
  List<DayMatch> dayMatches;

  CalendarDailyCourtMatch({
    required this.court,
    required this.dayMatches,
  });
}
