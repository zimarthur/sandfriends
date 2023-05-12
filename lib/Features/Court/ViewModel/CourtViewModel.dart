import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Court/Model/CourtAvailableHours.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableDay.dart';

import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/CourtRepoImp.dart';

class CourtViewModel extends ChangeNotifier {
  final courtRepo = CourtRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  int selectedPhotoIndex = 0;
  late Store store;
  List<CourtAvailableHours> courtAvailableHours = [];
  DateTime? selectedDate;

  void initCourtViewModel(Store newStore, AvailableDay? availableDay) {
    store = newStore;
    courtAvailableHours.clear();
    if (availableDay != null) {
      selectedDate = availableDay.day;
      for (var avHour in availableDay.stores.first.availableHours) {
        for (var court in avHour.availableCourts) {
          try {
            courtAvailableHours
                .firstWhere(
                  (courtAvHour) =>
                      courtAvHour.court.idStoreCourt ==
                      court.court.idStoreCourt,
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
    }
    notifyListeners();
  }

  void onSelectedPhotoChanged(int newIndex) {
    selectedPhotoIndex = newIndex;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
