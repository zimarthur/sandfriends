import '../../Enum/EnumDiscountType.dart';
import 'Coupon.dart';

class CouponUser extends Coupon {
  CouponUser({
    required super.idCoupon,
    required super.couponCode,
    required super.value,
    required super.discountType,
  });

  factory CouponUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return CouponUser(
      idCoupon: json["IdCoupon"],
      couponCode: json["Code"],
      discountType: getDiscountTypeFromString(
        json["DiscountType"],
      ),
      value: double.parse(
        json["Value"],
      ),
    );
  }
}
