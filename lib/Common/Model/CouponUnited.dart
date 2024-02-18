import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import '../Enum/EnumCouponStatus.dart';
import '../Enum/EnumDiscountType.dart';
import 'Hour.dart';
import 'package:intl/intl.dart';

class CouponUnited {
  int idCoupon;
  String couponCode;
  double value;
  EnumDiscountType discountType;
  bool? isValid;
  DateTime? creationDate;
  DateTime? startingDate;
  DateTime? endingDate;
  Hour? hourBegin;
  Hour? hourEnd;
  int? timesUsed;
  double? profit;

  String get valueText {
    if (discountType == EnumDiscountType.Fixed) {
      return value.formatPrice();
    } else {
      return "${value.toStringAsFixed(0)}%";
    }
  }

  bool get isCouponPercentage => discountType == EnumDiscountType.Percentage;

  double calculateDiscount(double cost) {
    if (isCouponPercentage) {
      return value * cost / 100;
    }
    return value;
  }

  String? get hourDescription =>
      "${hourBegin?.hourString} - ${hourEnd?.hourString}";

  String? get dateDescription => startingDate == null || endingDate == null
      ? null
      : "${DateFormat('dd/MM').format(startingDate!)} - ${DateFormat('dd/MM').format(endDateTime!)}";
  DateTime? get startDateTime => startingDate == null || hourBegin == null
      ? null
      : DateFormat("dd/MM/yyyy HH:mm").parse(
          "${DateFormat('dd/MM/yyyy').format(
            startingDate!,
          )} ${hourBegin!.hourString}",
        );

  DateTime? get endDateTime => endingDate == null || hourEnd == null
      ? null
      : DateFormat("dd/MM/yyyy HH:mm").parse(
          "${DateFormat('dd/MM/yyyy').format(
            endingDate!,
          )} ${hourEnd!.hourString}",
        );

  bool? get isValidToday {
    if (startDateTime == null || endDateTime == null) return null;
    DateTime now = DateTime.now();
    DateTime start = startDateTime!;
    DateTime end = endDateTime!;

    return now.isAfter(start) && now.isBefore(end);
  }

  bool? get canBeDisabled => isValidToday == null || startDateTime == null
      ? null
      : isValidToday! || DateTime.now().isBefore(startDateTime!);

  EnumCouponStatus? get couponStatus {
    if (isValid == null || isValidToday == null || endDateTime == null)
      return null;

    if (!isValid!) {
      return EnumCouponStatus.Invalid;
    } else {
      if (isValidToday!) {
        return EnumCouponStatus.Valid;
      } else if (DateTime.now().isAfter(endDateTime!)) {
        return EnumCouponStatus.Expired;
      } else {
        return EnumCouponStatus.Unavailable;
      }
    }
  }

  CouponUnited({
    required this.idCoupon,
    required this.couponCode,
    required this.value,
    required this.discountType,
    required this.isValid,
    required this.creationDate,
    required this.startingDate,
    required this.endingDate,
    required this.hourBegin,
    required this.hourEnd,
    required this.timesUsed,
    required this.profit,
  });

  factory CouponUnited.fromJson(
    Map<String, dynamic> json, {
    List<Hour>? referenceHours,
  }) {
    return CouponUnited(
      idCoupon: json["IdCoupon"],
      couponCode: json["Code"],
      discountType: getDiscountTypeFromString(
        json["DiscountType"],
      ),
      value: double.parse(
        json["Value"],
      ),
      creationDate: json["DateCreated"] == null
          ? null
          : DateFormat("dd/MM/yyyy").parse(
              json["DateCreated"],
            ),
      startingDate: json["DateBeginValid"] == null
          ? null
          : DateFormat("dd/MM/yyyy").parse(
              json["DateBeginValid"],
            ),
      endingDate: json["DateEndValid"] == null
          ? null
          : DateFormat("dd/MM/yyyy").parse(
              json["DateEndValid"],
            ),
      hourBegin: json["IdTimeBeginValid"] == null
          ? null
          : referenceHours!.firstWhere(
              (hour) => hour.hour == json["IdTimeBeginValid"],
            ),
      hourEnd: json["IdTimeEndValid"] == null
          ? null
          : referenceHours!.firstWhere(
              (hour) => hour.hour == json["IdTimeEndValid"],
            ),
      isValid: json["IsValid"],
      timesUsed: json["TimesUsed"],
      profit: json["Profit"] == null
          ? null
          : double.parse(
              json["Profit"].toString(),
            ),
    );
  }
}
