import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Court/Model/CourtAvailableHours.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Hour.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
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
  List<HourPrice> selectedHourPrices = [];
  Court? selectedCourt;
  DateTime? selectedDate;
  Sport? selectedSport;

  Hour? get reservationStartTime => selectedHourPrices
      .reduce((curr, next) => curr.hour.hour < next.hour.hour ? curr : next)
      .hour;

  Hour? get reservationEndTime => selectedHourPrices
      .reduce((curr, next) => curr.hour.hour > next.hour.hour ? curr : next)
      .hour;

  int? get reservationCost {
    int totalCost = 0;
    for (var hourPrice in selectedHourPrices) {
      totalCost += hourPrice.price;
    }
    return totalCost;
  }

  void initCourtViewModel(
    Store newStore,
    List<CourtAvailableHours>? newCourtAvailableHours,
    HourPrice? newselectedHourPrice,
    DateTime? newSelectedDate,
    Sport? newSelectedSport,
  ) {
    store = newStore;
    courtAvailableHours.clear();

    if (newCourtAvailableHours != null) {
      selectedDate = newSelectedDate;
      selectedSport = newSelectedSport;
      courtAvailableHours = newCourtAvailableHours;
      selectedHourPrices.add(newselectedHourPrice!);
      selectedCourt = courtAvailableHours
          .firstWhere(
            (court) => court.hourPrices.any(
              (hourPrice) => hourPrice == selectedHourPrices.first,
            ),
          )
          .court;
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

  void onTapHourPrice(Court court, HourPrice hourPrice) {
    if (court.idStoreCourt != selectedCourt!.idStoreCourt) {
      selectedCourt = court;
      selectedHourPrices.clear();
      selectedHourPrices.add(hourPrice);
    } else {
      final minHour = selectedHourPrices
          .reduce((curr, next) => curr.hour.hour < next.hour.hour ? curr : next)
          .hour
          .hour;
      final maxHour = selectedHourPrices
          .reduce((curr, next) => curr.hour.hour > next.hour.hour ? curr : next)
          .hour
          .hour;
      if ((hourPrice.hour.hour == maxHour || hourPrice.hour.hour == minHour) &&
          selectedHourPrices.length > 1) {
        selectedHourPrices.removeWhere((hrPrice) => hrPrice == hourPrice);
      } else if (((hourPrice.hour.hour - minHour).abs() == 1 ||
              (hourPrice.hour.hour - maxHour).abs() == 1) &&
          ((hourPrice.hour.hour > maxHour || hourPrice.hour.hour < minHour))) {
        selectedHourPrices.add(hourPrice);
      } else {
        selectedHourPrices.clear();
        selectedHourPrices.add(hourPrice);
      }
    }
    notifyListeners();
  }

  void courtReservation(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    courtRepo
        .courtReservation(
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      selectedCourt!.idStoreCourt,
      selectedSport!.idSport,
      selectedDate!,
      reservationStartTime!.hour,
      Provider.of<CategoriesProvider>(context, listen: false)
          .getHourEnd(
            reservationEndTime!,
          )
          .hour,
      reservationCost!,
    )
        .then((response) {
      modalMessage = SFModalMessage(
        message: response.userMessage!,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            Navigator.pushNamed(context, '/home');
          } else {
            pageStatus = PageStatus.OK;
            notifyListeners();
          }
        },
        buttonText: response.responseStatus == NetworkResponseStatus.alert
            ? "Concluído"
            : "Voltar",
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }
}
