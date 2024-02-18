import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

import '../../Enum/EnumDiscountType.dart';

abstract class Coupon {
  int idCoupon;
  String couponCode;
  double value;
  EnumDiscountType discountType;

  Coupon({
    required this.idCoupon,
    required this.couponCode,
    required this.value,
    required this.discountType,
  });

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
}
