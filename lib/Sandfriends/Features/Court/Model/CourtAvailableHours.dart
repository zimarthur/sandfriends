import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';

import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Store/StoreComplete.dart';
import '../../../../Common/Model/HourPrice/HourPriceUser.dart';

class CourtAvailableHours {
  Court court;
  List<HourPriceUser> hourPrices;

  CourtAvailableHours({
    required this.court,
    required this.hourPrices,
  });
}

List<CourtAvailableHours> toCourtAvailableHours(
  List<AvailableDay> availableDays,
  int? weekday,
  DateTime? day,
  StoreUser store,
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
              HourPriceUser(
                hour: avHour.hour,
                price: court.price,
              ),
            );
      } catch (e) {
        List<HourPriceUser> newHourPrices = [
          HourPriceUser(
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
