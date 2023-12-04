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
}

enum OrderBy { distance, price }
