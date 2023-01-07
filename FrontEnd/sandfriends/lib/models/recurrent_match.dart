import 'package:intl/intl.dart';
import 'package:sandfriends/models/match.dart';

import 'court.dart';

class RecurrentMatch {
  final int idRecurrentMatch;
  final DateTime creationDate;
  final DateTime lastPaymentDate;
  final int weekday;
  final String timeBegin;
  final String timeEnd;
  final Court court;
  final int recurrentMatchesCounter;
  final List<Match> monthRecurrentMatches = [];

  RecurrentMatch({
    required this.idRecurrentMatch,
    required this.creationDate,
    required this.lastPaymentDate,
    required this.weekday,
    required this.timeBegin,
    required this.timeEnd,
    required this.court,
    required this.recurrentMatchesCounter,
  });

  int currentMonthPrice() {
    int priceSum = 0;
    for (int i = 0; i < monthRecurrentMatches.length; i++) {
      priceSum += monthRecurrentMatches[i].cost;
    }
    return priceSum;
  }
}

RecurrentMatch recurrentMatchFromJson(Map<String, dynamic> json) {
  var newRecurrentMatch = RecurrentMatch(
    idRecurrentMatch: json['IdRecurrentMatch'],
    creationDate: DateFormat('yyyy-MM-dd HH:mm')
        .parse("${json['CreationDate']} ${json['TimeBegin']}"),
    lastPaymentDate: DateFormat('yyyy-MM-dd').parse(json['LastPaymentDate']),
    weekday: json['Weekday'],
    timeBegin: json['TimeBegin'],
    timeEnd: json['TimeEnd'],
    court: courtFromJson(json['StoreCourt']),
    recurrentMatchesCounter: json['RecurrentMatchCounter'],
  );

  for (int i = 0; i < json['NextRecurrentMatches'].length; i++) {
    newRecurrentMatch.monthRecurrentMatches
        .add(matchFromJson(json['NextRecurrentMatches'][i]));
  }

  return newRecurrentMatch;
}
