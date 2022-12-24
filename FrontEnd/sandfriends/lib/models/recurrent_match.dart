import 'package:intl/intl.dart';
import 'package:sandfriends/models/match.dart';

import 'court.dart';

class RecurrentMatch {
  final int idRecurrentMatch;
  final DateTime creationDate;
  final int weekday;
  final String timeBegin;
  final String timeEnd;
  final Court court;
  final int recurrentMatchesCounter;
  final List<Match> monthRecurrentMatches = [];

  RecurrentMatch({
    required this.idRecurrentMatch,
    required this.creationDate,
    required this.weekday,
    required this.timeBegin,
    required this.timeEnd,
    required this.court,
    required this.recurrentMatchesCounter,
  });
}

RecurrentMatch recurrentMatchFromJson(Map<String, dynamic> json) {
  var newRecurrentMatch = RecurrentMatch(
    idRecurrentMatch: json['IdRecurrentMatch'],
    creationDate: DateFormat('yyyy-MM-dd HH:mm')
        .parse("${json['CreationDate']} ${json['TimeBegin']}"),
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
