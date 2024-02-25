import '../Coupon/Coupon.dart';
import '../Court.dart';
import '../Hour.dart';
import '../PaymentStatus.dart';
import '../SelectedPayment.dart';
import '../Sport.dart';

abstract class AppMatch {
  int idMatch;
  int idRecurrentMatch;
  DateTime date;
  double cost;
  Hour timeBegin;
  Hour timeEnd;
  bool canceled;
  String creatorNotes;
  Court court;
  Sport sport;
  SelectedPayment selectedPayment;
  PaymentStatus paymentStatus;
  DateTime paymentExpirationDate;

  AppMatch({
    required this.idMatch,
    required this.idRecurrentMatch,
    required this.date,
    required this.cost,
    required this.timeBegin,
    required this.timeEnd,
    required this.canceled,
    required this.creatorNotes,
    required this.court,
    required this.sport,
    required this.selectedPayment,
    required this.paymentStatus,
    required this.paymentExpirationDate,
  });

  bool get isFromRecurrentMatch => idRecurrentMatch != 0;

  bool get isPaymentExpired {
    return DateTime.now().isAfter(paymentExpirationDate) &&
        paymentStatus == PaymentStatus.Pending;
  }

  bool get payInStore => selectedPayment == SelectedPayment.PayInStore;

  String get matchHourDescription =>
      "${timeBegin.hourString} - ${timeEnd.hourString}";

  int get matchDuration {
    return timeEnd.hour - timeBegin.hour;
  }
}
