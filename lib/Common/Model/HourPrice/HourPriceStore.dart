import '../Hour.dart';

class HourPriceStore {
  Hour startingHour;
  Hour endingHour;
  int price;
  int? recurrentPrice;
  bool newPriceRule = false;

  HourPriceStore({
    required this.startingHour,
    required this.price,
    required this.recurrentPrice,
    required this.endingHour,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is HourPriceStore == false) return false;
    HourPriceStore otherHourPrice = other as HourPriceStore;
    return startingHour.hour == otherHourPrice.startingHour.hour &&
        endingHour.hour == otherHourPrice.endingHour.hour &&
        price == otherHourPrice.price &&
        recurrentPrice == otherHourPrice.recurrentPrice;
  }

  @override
  int get hashCode =>
      startingHour.hashCode ^ endingHour.hashCode ^ price.hashCode;

  factory HourPriceStore.copyFrom(HourPriceStore refHourPrice) {
    return HourPriceStore(
      startingHour: refHourPrice.startingHour,
      price: refHourPrice.price,
      recurrentPrice: refHourPrice.recurrentPrice,
      endingHour: refHourPrice.endingHour,
    );
  }
}
