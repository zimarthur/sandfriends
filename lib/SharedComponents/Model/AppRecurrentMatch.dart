import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';

import 'Court.dart';
import 'Hour.dart';
import 'Sport.dart';

class AppRecurrentMatch {
  final int idRecurrentMatch;
  final DateTime creationDate;
  final DateTime lastPaymentDate;
  final int weekday;
  final Hour timeBegin;
  final Hour timeEnd;
  final Sport sport;
  final Court court;
  final int recurrentMatchesCounter;
  final List<AppMatch> monthRecurrentMatches = [];

  AppRecurrentMatch({
    required this.idRecurrentMatch,
    required this.creationDate,
    required this.lastPaymentDate,
    required this.weekday,
    required this.timeBegin,
    required this.timeEnd,
    required this.sport,
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

  factory AppRecurrentMatch.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    var newRecurrentMatch = AppRecurrentMatch(
      idRecurrentMatch: json['IdRecurrentMatch'],
      creationDate: DateFormat('dd/MM/yyyy').parse(json['CreationDate']),
      lastPaymentDate: DateFormat('dd/MM/yyyy').parse(json['LastPaymentDate']),
      weekday: json['Weekday'],
      timeBegin:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeBegin"]),
      timeEnd:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeEnd"]),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      court: Court.fromJsonMatch(json['StoreCourt']),
      recurrentMatchesCounter: json['RecurrentMatchCounter'],
    );

    for (int i = 0; i < json['NextRecurrentMatches'].length; i++) {
      newRecurrentMatch.monthRecurrentMatches.add(AppMatch.fromJson(
          json['NextRecurrentMatches'][i], referenceHours, referenceSports));
    }

    return newRecurrentMatch;
  }
}
