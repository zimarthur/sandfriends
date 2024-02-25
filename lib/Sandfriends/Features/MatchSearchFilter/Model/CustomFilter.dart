import 'package:sandfriends/Common/Model/Sport.dart';

class CustomFilter {
  OrderBy orderBy;
  Sport sport;

  CustomFilter({
    required this.orderBy,
    required this.sport,
  });

  factory CustomFilter.copyFrom(CustomFilter ref) {
    return CustomFilter(orderBy: ref.orderBy, sport: ref.sport);
  }

  @override
  int get hashCode => orderBy.hashCode ^ sport.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is CustomFilter == false) return false;
    CustomFilter otherHourPrice = other as CustomFilter;
    return orderBy == otherHourPrice.orderBy && sport == otherHourPrice.sport;
  }
}

enum OrderBy { distance, price }
