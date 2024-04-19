import '../Hour.dart';

class HourPriceUser {
  Hour hour;
  int price;

  HourPriceUser({
    required this.hour,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HourPriceUser) return false;
    return hour.hour == other.hour.hour && price == other.price;
  }

  @override
  int get hashCode => hour.hashCode ^ price.hashCode;

  factory HourPriceUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> availableHours,
  ) {
    return HourPriceUser(
      hour: availableHours
          .firstWhere((hour) => hour.hour == json["IdAvailableHour"]),
      price: json["Price"],
    );
  }
}
