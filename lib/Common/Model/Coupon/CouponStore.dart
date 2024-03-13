import 'package:intl/intl.dart';

import '../../Enum/EnumCouponStatus.dart';
import '../../Enum/EnumDiscountType.dart';
import '../Hour.dart';
import 'Coupon.dart';

class CouponStore extends Coupon {
  bool isValid;
  DateTime creationDate;
  DateTime startingDate;
  DateTime endingDate;
  Hour hourBegin;
  Hour hourEnd;
  int timesUsed;
  double profit;

  CouponStore({
    required super.idCoupon,
    required super.couponCode,
    required super.value,
    required super.discountType,
    required this.isValid,
    required this.creationDate,
    required this.startingDate,
    required this.endingDate,
    required this.hourBegin,
    required this.hourEnd,
    required this.timesUsed,
    required this.profit,
  });

  String get hourDescription =>
      "${hourBegin.hourString} - ${hourEnd.hourString}";

  String get dateDescription =>
      "${DateFormat('dd/MM').format(startingDate)} - ${DateFormat('dd/MM').format(endDateTime)}";
  DateTime get startDateTime => DateFormat("dd/MM/yyyy HH:mm").parse(
        "${DateFormat('dd/MM/yyyy').format(
          startingDate,
        )} ${hourBegin.hourString}",
      );

  DateTime get endDateTime => DateFormat("dd/MM/yyyy HH:mm").parse(
        "${DateFormat('dd/MM/yyyy').format(
          endingDate,
        )} ${hourEnd.hourString}",
      );

  bool get isValidToday {
    DateTime now = DateTime.now();
    DateTime start = startDateTime;
    DateTime end = endDateTime;
    print("asd $startDateTime");
    print("asd $endDateTime");
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get canBeDisabled =>
      isValidToday || DateTime.now().isBefore(startDateTime);

  EnumCouponStatus get couponStatus {
    if (!isValid) {
      return EnumCouponStatus.Invalid;
    } else {
      if (isValidToday) {
        return EnumCouponStatus.Valid;
      } else if (DateTime.now().isAfter(endDateTime)) {
        return EnumCouponStatus.Expired;
      } else {
        return EnumCouponStatus.Unavailable;
      }
    }
  }

  factory CouponStore.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
  ) {
    return CouponStore(
      idCoupon: json["IdCoupon"],
      couponCode: json["Code"],
      discountType: getDiscountTypeFromString(
        json["DiscountType"],
      ),
      value: double.parse(
        json["Value"],
      ),
      creationDate: DateFormat("dd/MM/yyyy").parse(
        json["DateCreated"],
      ),
      startingDate: DateFormat("dd/MM/yyyy").parse(
        json["DateBeginValid"],
      ),
      endingDate: DateFormat("dd/MM/yyyy").parse(
        json["DateEndValid"],
      ),
      hourBegin: referenceHours.firstWhere(
        (hour) => hour.hour == json["IdTimeBeginValid"],
      ),
      hourEnd: referenceHours.firstWhere(
        (hour) => hour.hour == json["IdTimeEndValid"],
      ),
      isValid: json["IsValid"],
      timesUsed: json["TimesUsed"],
      profit: double.parse(
        json["Profit"].toString(),
      ),
    );
  }
}
