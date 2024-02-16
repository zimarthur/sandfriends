class Coupon {
  int idCoupon;
  String couponCode;
  double value;
  String discountType;

  bool get isCouponPercentage => discountType == "PERCENTAGE";

  double calculateDiscount(double cost) {
    if (isCouponPercentage) {
      return value * cost / 100;
    }
    return value;
  }

  Coupon({
    required this.idCoupon,
    required this.couponCode,
    required this.value,
    required this.discountType,
  });

  factory Coupon.fromJson(
    Map<String, dynamic> json,
  ) {
    return Coupon(
      idCoupon: json["IdCoupon"],
      couponCode: json["Code"],
      discountType: json["DiscountType"],
      value: double.parse(
        json["Value"],
      ),
    );
  }
}
