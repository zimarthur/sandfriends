import '../../../../Common/Model/Hour.dart';

class HourPrice {
  Hour hour;
  int price;

  HourPrice({
    required this.hour,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HourPrice) return false;
    return hour.hour == other.hour.hour && price == other.price;
  }

  @override
  int get hashCode => hour.hashCode ^ price.hashCode;
}
