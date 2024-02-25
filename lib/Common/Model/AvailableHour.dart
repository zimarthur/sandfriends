import 'package:sandfriends/Common/Model/AvailableCourt.dart';

import 'HourPrice/HourPriceUser.dart';
import 'Hour.dart';

class AvailableHour {
  Hour hour;
  List<AvailableCourt> availableCourts = [];

  AvailableHour(
    this.hour,
    this.availableCourts,
  );

  HourPriceUser get lowestHourPrice => HourPriceUser(
        hour: hour,
        price: availableCourts
            .reduce((curr, next) => curr.price < next.price ? curr : next)
            .price,
      );
}
