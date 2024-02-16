import 'dart:convert';

import '../../../../Common/Model/AvailableCourt.dart';
import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/AvailableStore.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Store.dart';
import '../../Court/Model/CourtAvailableHours.dart';
import '../../Court/Model/HourPrice.dart';

List<AvailableDay> recurrentMatchDecoder(String response) {
  final List<AvailableDay> availableDays = [];

  List<Store> receivedStores = [];

  final responseBody = json.decode(response);
  final responseDates = responseBody['Dates'];
  final responseStores = responseBody['Stores'];

  for (var store in responseStores) {
    receivedStores.add(
      Store.fromJson(
        store,
      ),
    );
  }

  for (var date in responseDates) {
    int newWeekday = int.parse(date["Date"]);
    List<AvailableStore> availableStores = [];
    Store newStore;
    for (var store in date["Stores"]) {
      newStore = Store.copyWith(
        receivedStores.firstWhere(
          (recStore) => recStore.idStore == store["IdStore"],
        ),
      );
      List<AvailableHour> availableHours = [];
      for (var hour in store["Hours"]) {
        List<AvailableCourt> availableCourts = [];
        for (var court in hour["Courts"]) {
          availableCourts.add(
            AvailableCourt(
              court: Court.copyWith(
                newStore.courts.firstWhere(
                  (recCourt) => recCourt.idStoreCourt == court["IdStoreCourt"],
                ),
              ),
              price: court["Price"],
            ),
          );
        }
        availableHours.add(
          AvailableHour(
            Hour(
              hour: hour["TimeInteger"],
              hourString: hour["TimeBegin"],
            ),
            availableCourts,
          ),
        );
      }
      availableStores.add(
        AvailableStore(
          store: newStore,
          availableHours: availableHours,
        ),
      );
    }
    availableDays.add(
      AvailableDay(
        weekday: newWeekday,
        stores: availableStores,
      ),
    );
  }
  return availableDays;
}
