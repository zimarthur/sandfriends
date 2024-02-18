import '../Hour.dart';

class PriceRule {
  Hour startingHour;
  Hour endingHour;
  int price;
  int? priceRecurrent;

  PriceRule({
    required this.startingHour,
    required this.endingHour,
    required this.price,
    required this.priceRecurrent,
  });
}
