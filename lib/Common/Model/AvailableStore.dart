import 'package:sandfriends/Common/Model/AvailableHour.dart';

import 'Store/StoreComplete.dart';

class AvailableStore {
  Store store;
  List<AvailableHour> availableHours = [];

  AvailableStore({
    required this.store,
    required this.availableHours,
  });
}
