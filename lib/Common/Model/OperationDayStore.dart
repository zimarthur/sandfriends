import 'HourPrice/HourPriceStore.dart';
import 'Hour.dart';
import 'SandfriendsQuadras/PriceRule.dart';

class OperationDayStore {
  int weekday;
  List<HourPriceStore> prices = [];
  bool isExpanded = false;

  bool get allowReccurrent =>
      prices.any((hourPrice) => hourPrice.recurrentPrice != null);
  bool get isEnabled => prices.isNotEmpty;
  Hour get startingHour => prices
      .reduce((a, b) => a.startingHour.hour < b.startingHour.hour ? a : b)
      .startingHour;
  Hour get endingHour => prices
      .reduce((a, b) => a.endingHour.hour > b.endingHour.hour ? a : b)
      .endingHour;

  int get lowestPrice =>
      prices.reduce((a, b) => a.price < b.price ? a : b).price;
  int get highestPrice =>
      prices.reduce((a, b) => a.price > b.price ? a : b).price;
  int? get lowestRecurrentPrice {
    if (prices.any((element) => element.recurrentPrice == null)) {
      return null;
    } else {
      return prices
          .reduce((a, b) => a.recurrentPrice! < b.recurrentPrice! ? a : b)
          .recurrentPrice;
    }
  }

  int? get highestRecurrentPrice {
    if (prices.any((element) => element.recurrentPrice == null)) {
      return null;
    } else {
      return prices
          .reduce((a, b) => a.recurrentPrice! > b.recurrentPrice! ? a : b)
          .recurrentPrice;
    }
  }

  OperationDayStore({
    required this.weekday,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is OperationDayStore == false) return false;
    OperationDayStore otherOpDay = other as OperationDayStore;
    if (prices.length != otherOpDay.prices.length) {
      return false;
    }
    for (var price in prices) {
      if (price !=
          otherOpDay.prices.firstWhere(
              (hourPrice) => price.startingHour == hourPrice.startingHour)) {
        return false;
      }
    }

    return weekday == otherOpDay.weekday;
  }

  @override
  int get hashCode => weekday.hashCode ^ prices.hashCode;

  List<PriceRule> get priceRules {
    List<PriceRule> calculatedRules = [];

    PriceRule? newPriceRule;
    for (var hourPrice in prices) {
      if (prices.first == hourPrice) {
        newPriceRule = PriceRule(
          startingHour: hourPrice.startingHour,
          endingHour: hourPrice.endingHour,
          price: hourPrice.price,
          priceRecurrent: hourPrice.recurrentPrice,
        );
      } else if (hourPrice.price != newPriceRule!.price ||
          hourPrice.recurrentPrice != newPriceRule.priceRecurrent ||
          hourPrice.newPriceRule) {
        newPriceRule.endingHour = hourPrice.startingHour;
        calculatedRules.add(newPriceRule);
        newPriceRule = PriceRule(
          startingHour: hourPrice.startingHour,
          endingHour: hourPrice.endingHour,
          price: hourPrice.price,
          priceRecurrent: hourPrice.recurrentPrice,
        );
      }
      if (prices.last == hourPrice) {
        newPriceRule.endingHour = hourPrice.endingHour;
        calculatedRules.add(newPriceRule);
        newPriceRule = PriceRule(
          startingHour: hourPrice.startingHour,
          endingHour: hourPrice.endingHour,
          price: hourPrice.price,
          priceRecurrent: hourPrice.recurrentPrice,
        );
      }
    }

    return calculatedRules;
  }

  factory OperationDayStore.copyFrom(OperationDayStore refOpDay) {
    final opDay = OperationDayStore(weekday: refOpDay.weekday);
    for (var price in refOpDay.prices) {
      opDay.prices.add(
        HourPriceStore.copyFrom(price),
      );
    }
    return opDay;
  }
}
