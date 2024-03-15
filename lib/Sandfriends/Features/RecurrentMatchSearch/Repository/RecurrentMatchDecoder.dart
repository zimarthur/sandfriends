import 'dart:convert';

import 'package:sandfriends/Common/Model/Store/StoreUser.dart';

import '../../../../Common/Model/AvailableCourt.dart';
import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/AvailableStore.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Store/StoreComplete.dart';
import '../../../../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../../../../Common/Model/HourPrice/HourPriceUser.dart';

List<AvailableDay> recurrentMatchDecoder(String response) {
  final List<AvailableDay> availableDays = [];

  List<StoreUser> receivedStores = [];

  final responseBody = json.decode(response);
  final responseDates = responseBody['Dates'];
  final responseStores = responseBody['Stores'];

  for (var store in responseStores) {
    receivedStores.add(
      StoreUser.fromJson(
        store,
      ),
    );
  }

  for (var date in responseDates) {
    int newWeekday = int.parse(date["Date"]);
    List<AvailableStore> availableStores = [];
    StoreUser newStore;
    for (var store in date["Stores"]) {
      newStore = StoreUser.copyWith(
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
              court: Court.copyFrom(
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
