import 'package:sandfriends/SharedComponents/Model/Sport.dart';

class CustomFilter {
  OrderBy orderBy;
  Sport sport;
  List<int> storeIds;

  CustomFilter({
    required this.orderBy,
    required this.sport,
    this.storeIds = const [],
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
    return orderBy == otherHourPrice.orderBy &&
        sport == otherHourPrice.sport &&
        storeIds == otherHourPrice.storeIds;
  }
}

enum OrderBy { distance, price }
