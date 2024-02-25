import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchStore.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

import '../AppMatch/AppMatch.dart';
import '../AppMatch/AppMatchUser.dart';
import '../Court.dart';
import '../Hour.dart';
import '../Sport.dart';
import 'AppRecurrentMatch.dart';

class AppRecurrentMatchStore extends AppRecurrentMatch {
  UserStore creator;

  bool canceled;
  bool blocked;
  String blockedReason;

  List<AppMatchUser> _nextRecurrentMatches = [];
  @override
  List<AppMatchUser> get nextRecurrentMatches => _nextRecurrentMatches;

  AppRecurrentMatchStore({
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
    required this.creator,
    required this.canceled,
    required this.blocked,
    required this.blockedReason,
  });

  bool get payInStore => blocked ? true : nextRecurrentMatches.first.payInStore;

  factory AppRecurrentMatchStore.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    List<AppMatch> nextRecurrentMatches = [];
    for (var match in json["NextRecurrentMatches"]) {
      nextRecurrentMatches.add(
        AppMatchStore.fromJson(
          match,
          referenceHours,
          referenceSports,
        ),
      );
    }
    AppRecurrentMatchStore recurrentMatch = AppRecurrentMatchStore(
      idRecurrentMatch: json["IdRecurrentMatch"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["CreationDate"],
      ),
      lastPaymentDate: DateFormat("dd/MM/yyyy").parse(
        json["LastPaymentDate"],
      ),
      validUntil: DateFormat("dd/MM/yyyy").parse(
        json["ValidUntil"],
      ),
      weekday: json["Weekday"],
      timeBegin:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeBegin"]),
      timeEnd:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeEnd"]),
      court: Court.fromJsonMatch(json["StoreCourt"]),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      creator: UserStore.fromUserMinJson(json),
      matchCounter: json["RecurrentMatchCounter"],
      canceled: json["Canceled"] ?? false,
      blocked: json["Blocked"] ?? false,
      blockedReason: json["BlockedReason"] ?? "",
    );
    recurrentMatch._nextRecurrentMatches =
        nextRecurrentMatches as List<AppMatchUser>;
    return recurrentMatch;
  }

  factory AppRecurrentMatchStore.copyWith(AppRecurrentMatchStore refMatch) {
    AppRecurrentMatchStore recurrentMatch = AppRecurrentMatchStore(
      idRecurrentMatch: refMatch.idRecurrentMatch,
      creationDate: refMatch.creationDate,
      lastPaymentDate: refMatch.lastPaymentDate,
      validUntil: refMatch.validUntil,
      weekday: refMatch.weekday,
      timeBegin: refMatch.timeBegin,
      timeEnd: refMatch.timeEnd,
      court: refMatch.court,
      sport: refMatch.sport,
      creator: refMatch.creator,
      matchCounter: refMatch.matchCounter,
      canceled: refMatch.canceled,
      blocked: refMatch.blocked,
      blockedReason: refMatch.blockedReason,
    );
    recurrentMatch._nextRecurrentMatches = refMatch.nextRecurrentMatches
        .map((match) => AppMatchStore.copyWith(match as AppMatchStore))
        .cast<AppMatchUser>()
        .toList();
    return recurrentMatch;
  }
}
