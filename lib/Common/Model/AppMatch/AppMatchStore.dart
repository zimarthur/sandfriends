import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatch.dart';

import '../Court.dart';
import '../Hour.dart';
import '../PaymentStatus.dart';
import '../SelectedPayment.dart';
import '../Sport.dart';
import '../User/UserStore.dart';

class AppMatchStore extends AppMatch {
  double netCost;
  UserStore matchCreator;
  bool blocked;
  String blockedReason;
  DateTime creationDate;

  AppMatchStore({
    required super.idMatch,
    required super.idRecurrentMatch,
    required super.date,
    required super.cost,
    required super.timeBegin,
    required super.timeEnd,
    required super.canceled,
    required super.creatorNotes,
    required super.court,
    required super.sport,
    required super.selectedPayment,
    required super.paymentStatus,
    required super.paymentExpirationDate,
    required this.netCost,
    required this.matchCreator,
    required this.blocked,
    required this.blockedReason,
    required this.creationDate,
  });

  factory AppMatchStore.fromJson(Map<String, dynamic> json,
      List<Hour> referenceHours, List<Sport> referenceSports) {
    Hour timeBegin = referenceHours.firstWhere(
      (hour) => hour.hour == json['TimeBegin'],
    );

    return AppMatchStore(
      idMatch: json["IdMatch"],
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["Date"],
      ),
      date: DateFormat("dd/MM/yyyy HH:mm").parse(
        "${json["Date"]} ${timeBegin.hourString}",
      ),
      timeBegin: timeBegin,
      timeEnd:
          referenceHours.firstWhere((hour) => hour.hour == json["TimeEnd"]),
      court: Court.fromJsonMatch(json["StoreCourt"]),
      cost: double.parse(json["Cost"].toString()),
      sport: referenceSports
          .firstWhere((sport) => sport.idSport == json["IdSport"]),
      creatorNotes: json["CreatorNotes"] ?? "",
      matchCreator: UserStore.fromUserMinJson(
        json,
      ),
      idRecurrentMatch: json["IdRecurrentMatch"],
      canceled: json["Canceled"],
      blocked: json["Blocked"] ?? false,
      blockedReason: json["BlockedReason"] ?? "",
      paymentStatus: decoderPaymentStatus(json['PaymentStatus']),
      selectedPayment: decoderSelectedPayment(json['PaymentType']),
      paymentExpirationDate: DateFormat('yyyy-MM-dd HH:mm:ss')
          .parse(json['PaymentExpirationDate']),
      netCost: double.parse(json["CostFinal"]),
    );
  }

  factory AppMatchStore.copyWith(AppMatchStore refMatch) {
    return AppMatchStore(
      idMatch: refMatch.idMatch,
      date: refMatch.date,
      cost: refMatch.cost,
      creationDate: refMatch.creationDate,
      creatorNotes: refMatch.creatorNotes,
      idRecurrentMatch: refMatch.idRecurrentMatch,
      court: refMatch.court,
      sport: refMatch.sport,
      timeBegin: refMatch.timeBegin,
      timeEnd: refMatch.timeEnd,
      matchCreator: refMatch.matchCreator,
      canceled: refMatch.canceled,
      blocked: refMatch.blocked,
      blockedReason: refMatch.blockedReason,
      paymentExpirationDate: refMatch.paymentExpirationDate,
      paymentStatus: refMatch.paymentStatus,
      selectedPayment: refMatch.selectedPayment,
      netCost: refMatch.netCost,
    );
  }
}
