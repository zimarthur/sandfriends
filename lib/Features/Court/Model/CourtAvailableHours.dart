import 'package:sandfriends/Utils/SFDateTime.dart';

import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/AvailableHour.dart';
import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Store.dart';
import 'HourPrice.dart';

class CourtAvailableHours {
  Court court;
  List<HourPrice> hourPrices;

  CourtAvailableHours({
    required this.court,
    required this.hourPrices,
  });
}

List<CourtAvailableHours> toCourtAvailableHours(
  List<AvailableDay> availableDays,
  int? weekday,
  DateTime? day,
  Store store,
) {
  if (availableDays.isEmpty) {
    return [];
  }
  List<CourtAvailableHours> courtAvailableHours = [];
  List<AvailableHour> filteredHours = availableDays
      .firstWhere((avDay) => weekday != null
          ? avDay.weekday == weekday
          : areInTheSameDay(avDay.day!, day!))
      .stores
      .firstWhere(
        (avStore) => avStore.store.idStore == store.idStore,
      )
      .availableHours;
  for (var avHour in filteredHours) {
    for (var court in avHour.availableCourts) {
      try {
        courtAvailableHours
            .firstWhere(
              (courtAvHour) =>
                  courtAvHour.court.idStoreCourt == court.court.idStoreCourt,
            )
            .hourPrices
            .add(
              HourPrice(
                hour: avHour.hour,
                price: court.price,
              ),
            );
      } catch (e) {
        List<HourPrice> newHourPrices = [
          HourPrice(
            hour: avHour.hour,
            price: court.price,
          ),
        ];
        courtAvailableHours.add(
          CourtAvailableHours(
            court: court.court,
            hourPrices: newHourPrices,
          ),
        );
      }
    }
  }
  return courtAvailableHours;
}
