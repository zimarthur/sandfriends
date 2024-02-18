import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';

import '../AppMatch/AppMatchStore.dart';
import '../AppMatch/AppMatchUser.dart';
import '../Court.dart';
import '../Hour.dart';
import '../Sport.dart';

class AppRecurrentMatchUser extends AppRecurrentMatch {
  List<AppMatchUser> _nextRecurrentMatches = [];
  @override
  List<AppMatchUser> get nextRecurrentMatches => _nextRecurrentMatches;

  AppRecurrentMatchUser({
    required super.idRecurrentMatch,
    required super.creationDate,
    required super.lastPaymentDate,
    required super.validUntil,
    required super.weekday,
    required super.timeBegin,
    required super.timeEnd,
    required super.sport,
    required super.court,
    required super.matchCounter,
  });

  factory AppRecurrentMatchUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    var newRecurrentMatch = AppRecurrentMatchUser(
      idRecurrentMatch: json['IdRecurrentMatch'],
      creationDate: DateFormat('dd/MM/yyyy').parse(json['CreationDate']),
      validUntil: DateFormat('dd/MM/yyyy').parse(json['ValidUntil']),
      lastPaymentDate: DateFormat('dd/MM/yyyy').parse(json['LastPaymentDate']),
      weekday: json['Weekday'],
      timeBegin:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeBegin"]),
      timeEnd:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeEnd"]),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      court: Court.fromJsonMatch(json['StoreCourt']),
      matchCounter: json['RecurrentMatchCounter'],
    );

    for (int i = 0; i < json['NextRecurrentMatches'].length; i++) {
      newRecurrentMatch._nextRecurrentMatches.add(
        AppMatchUser.fromJson(
          json['NextRecurrentMatches'][i],
          referenceHours,
          referenceSports,
        ),
      );
    }

    return newRecurrentMatch;
  }
}
