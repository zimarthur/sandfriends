import '../Hour.dart';

class PriceRule {
  Hour startingHour;
  Hour endingHour;
  int price;
  int? priceRecurrent;
  int priceTeacher;
  int? priceRecurrentTeacher;

  PriceRule({
    required this.startingHour,
    required this.endingHour,
    required this.price,
    required this.priceRecurrent,
    required this.priceTeacher,
    required this.priceRecurrentTeacher,
  });
}
