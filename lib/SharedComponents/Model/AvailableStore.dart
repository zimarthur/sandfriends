import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';

import 'Store.dart';

class AvailableStore {
  Store store;
  List<AvailableHour> availableHours = [];

  AvailableStore({
    required this.store,
    required this.availableHours,
  });
}
