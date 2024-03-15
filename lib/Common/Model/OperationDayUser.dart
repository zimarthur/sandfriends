import 'dart:math';

import 'Hour.dart';

class OperationDayUser {
  int weekday;
  Hour? startingHour;
  Hour? endingHour;

  OperationDayUser({
    required this.weekday,
    required this.startingHour,
    required this.endingHour,
  });

  bool get isClosed => startingHour == null || endingHour == null;

  String get hoursDescription => isClosed
      ? "fechado"
      : "${startingHour!.hourString} - ${endingHour!.hourString}";

  factory OperationDayUser.fromJson(
      Map<String, dynamic> json, List<Hour> availableHours) {
    return OperationDayUser(
      weekday: json["Weekday"],
      startingHour: json["StartingHour"] != null
          ? availableHours
              .firstWhere((hour) => json["StartingHour"] == hour.hour)
          : null,
      endingHour: json["EndingHour"] != null
          ? availableHours
              .firstWhere((hour) => (json["EndingHour"] + 1) == hour.hour)
          : null,
    );
  }
}
