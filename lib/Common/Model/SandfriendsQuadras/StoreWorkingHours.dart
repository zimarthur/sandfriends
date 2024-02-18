import '../Hour.dart';

class StoreWorkingDay {
  int weekday;
  Hour? startingHour;
  Hour? endingHour;
  bool isEnabled;

  StoreWorkingDay({
    required this.weekday,
    required this.isEnabled,
    this.startingHour,
    this.endingHour,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is StoreWorkingDay == false) return false;
    StoreWorkingDay otherStoreWorkingDay = other as StoreWorkingDay;

    return isEnabled == otherStoreWorkingDay.isEnabled &&
        startingHour == otherStoreWorkingDay.startingHour &&
        endingHour == otherStoreWorkingDay.endingHour &&
        weekday == otherStoreWorkingDay.weekday;
  }

  @override
  int get hashCode =>
      weekday.hashCode ^
      startingHour.hashCode ^
      endingHour.hashCode ^
      isEnabled.hashCode;

  factory StoreWorkingDay.copyFrom(StoreWorkingDay refWorkingHours) {
    return StoreWorkingDay(
      weekday: refWorkingHours.weekday,
      isEnabled: refWorkingHours.isEnabled,
      startingHour: refWorkingHours.startingHour,
      endingHour: refWorkingHours.endingHour,
    );
  }
}
