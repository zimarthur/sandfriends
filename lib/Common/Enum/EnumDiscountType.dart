enum EnumDiscountType { Fixed, Percentage }

extension EnumDiscountTypeString on EnumDiscountType {
  String get text {
    switch (this) {
      case EnumDiscountType.Fixed:
        return 'FIXED';
      case EnumDiscountType.Percentage:
        return 'PERCENTAGE';
    }
  }
}

EnumDiscountType getDiscountTypeFromString(String discountType) {
  if (discountType == "FIXED") {
    return EnumDiscountType.Fixed;
  } else {
    return EnumDiscountType.Percentage;
  }
}
