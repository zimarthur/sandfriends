import 'package:sandfriends/SharedComponents/Model/AvailableCourt.dart';

class AvailableHour {
  String hourBegin;
  String hourFinish;
  int hourIndex;
  List<AvailableCourt> availableCourts = [];

  AvailableHour(
    this.hourBegin,
    this.hourFinish,
    this.hourIndex,
    this.availableCourts,
  );

  int get lowestPrice => availableCourts
      .reduce((curr, next) => curr.price < next.price ? curr : next)
      .price;
}
