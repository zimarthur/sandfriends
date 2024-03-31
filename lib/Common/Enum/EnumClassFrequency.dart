enum EnumClassFrequency { None, OnceWeek, TwiceWeek }

EnumClassFrequency classFrequencyFromInt(int value) {
  if (value == 0) {
    return EnumClassFrequency.None;
  } else if (value == 1) {
    return EnumClassFrequency.OnceWeek;
  } else {
    return EnumClassFrequency.TwiceWeek;
  }
}

extension EnumClassFrequencyExtension on EnumClassFrequency {
  String get title {
    if (value == 0) {
      return "Avulso";
    } else {
      return "${value}x semana";
    }
  }

  int get value {
    switch (this) {
      case EnumClassFrequency.None:
        return 0;
      case EnumClassFrequency.OnceWeek:
        return 1;
      case EnumClassFrequency.TwiceWeek:
        return 2;
    }
  }
}
