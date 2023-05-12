import 'package:sandfriends/SharedComponents/Model/AvailableCourt.dart';

import '../../Features/Court/Model/HourPrice.dart';
import 'Hour.dart';

class AvailableHour {
  Hour hour;
  List<AvailableCourt> availableCourts = [];

  AvailableHour(
    this.hour,
    this.availableCourts,
  );

  HourPrice get lowestHourPrice => HourPrice(
        hour: hour,
        price: availableCourts
            .reduce((curr, next) => curr.price < next.price ? curr : next)
            .price,
      );
}
