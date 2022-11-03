import 'package:intl/intl.dart';

import 'court.dart';

class RecurrentMatch {
  final int idRecurrentMatch;
  final DateTime creationDate;
  final int weekday;
  final String timeBegin;
  final String timeEnd;
  final Court court;
  final int recurrentMatchesCounter;

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
    idRecurrentMatch: json['RecurrentMatch']['IdRecurrentMatch'],
    creationDate: DateFormat('yyyy-MM-dd HH:mm').parse(
        "${json['RecurrentMatch']['CreationDate']} ${json['RecurrentMatch']['TimeBegin']}"),
    weekday: json['RecurrentMatch']['Weekday'],
    timeBegin: json['RecurrentMatch']['TimeBegin'],
    timeEnd: json['RecurrentMatch']['TimeEnd'],
    court: courtFromJson(json['RecurrentMatch']['StoreCourt']),
    recurrentMatchesCounter: json['RecurrentMatchesCounter'],
  );

  return newRecurrentMatch;
}
