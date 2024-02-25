import 'package:sandfriends/Common/Model/AvailableHour.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';

import 'Store/StoreComplete.dart';

class AvailableStore {
  StoreUser store;
  List<AvailableHour> availableHours = [];

  AvailableStore({
    required this.store,
    required this.availableHours,
  });
}
