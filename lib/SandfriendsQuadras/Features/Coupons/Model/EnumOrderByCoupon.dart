enum EnumOrderByCoupon {
  DateAscending,
  DateDescending,
  MostUsed,
}

extension EnumOrderByCouponString on EnumOrderByCoupon {
  String get text {
    switch (this) {
      case EnumOrderByCoupon.DateAscending:
        return 'Data: antigas';
      case EnumOrderByCoupon.DateDescending:
        return 'Data: recentes';
      case EnumOrderByCoupon.MostUsed:
        return 'Mais utilizados';
    }
  }
}

List<EnumOrderByCoupon> orderByCouponOptions = [
  EnumOrderByCoupon.DateDescending,
  EnumOrderByCoupon.DateAscending,
  EnumOrderByCoupon.MostUsed
];
