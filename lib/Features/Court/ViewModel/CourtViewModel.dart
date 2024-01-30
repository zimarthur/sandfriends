import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Court/Model/CourtAvailableHours.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';
import 'package:tuple/tuple.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/AvailableCourt.dart';
import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/AvailableHour.dart';
import '../../../SharedComponents/Model/AvailableStore.dart';
import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Hour.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../MatchSearch/Repository/MatchSearchDecoder.dart';
import '../../MatchSearch/Repository/MatchSearchRepoImp.dart';
import '../../MatchSearch/View/CalendarModal.dart';
import '../../RecurrentMatchSearch/Repository/RecurrentMatchDecoder.dart';
import '../../RecurrentMatchSearch/Repository/RecurrentMatchSearchRepoImp.dart';
import '../Repository/CourtRepoImp.dart';

class CourtViewModel extends ChangeNotifier {
  final courtRepo = CourtRepoImp();
  final matchSearchRepo = MatchSearchRepoImp();
  final recurrentMatchSearchRepo = RecurrentMatchSearchRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  bool canTapBackground = true;
  bool isLoading = false;

  int selectedPhotoIndex = 0;
  Store? store;
  List<CourtAvailableHours> courtAvailableHours = [];
  List<HourPrice> selectedHourPrices = [];
  Court? selectedCourt;
  DateTime? selectedDate;
  int? selectedWeekday;
  bool? isRecurrent;
  late bool canMakeReservation;
  Hour? searchStartPeriod;
  Hour? searchEndPeriod;

  Sport? selectedSport;

  Widget? widgetForm;

  void setSport(BuildContext context, Sport sport) {
    selectedSport = sport;
    searchStoreAvailableHours(context);
    notifyListeners();
  }

  Hour? get reservationStartTime => selectedHourPrices.isEmpty
      ? null
      : selectedHourPrices
          .reduce((curr, next) => curr.hour.hour < next.hour.hour ? curr : next)
          .hour;

  Hour? get reservationEndTime => selectedHourPrices.isEmpty
      ? null
      : selectedHourPrices
          .reduce((curr, next) => curr.hour.hour > next.hour.hour ? curr : next)
          .hour;

  double? get reservationCost {
    double totalCost = 0;
    for (var hourPrice in selectedHourPrices) {
      totalCost += hourPrice.price;
    }
    return totalCost;
  }

  Future<void> initCourtViewModel(
    BuildContext context,
    Store? newStore,
    String? newIdStore,
    List<CourtAvailableHours>? newCourtAvailableHours,
    HourPrice? newselectedHourPrice,
    DateTime? newSelectedDate,
    int? newSelectedWeekday,
    Sport? newSelectedSport,
    bool? newIsRecurrent,
    bool newCanMakeReservation,
    Hour? newSearchStartPeriod,
    Hour? newSearchEndPeriod,
  ) async {
    canMakeReservation = newCanMakeReservation;
    isRecurrent = newIsRecurrent ?? false;
    courtAvailableHours.clear();
    store = newStore;
    if (store == null) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      final response = await courtRepo.getStore(context, newIdStore!);

      if (response.responseStatus == NetworkResponseStatus.success) {
        store = Store.fromJson(json.decode(response.responseBody!));
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        canTapBackground = false;
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (Route<dynamic> route) => false,
            );
          },
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    }

    if (newCourtAvailableHours != null) {
      selectedDate = newSelectedDate;
      selectedWeekday = newSelectedWeekday;
      selectedSport = newSelectedSport;
      courtAvailableHours = newCourtAvailableHours;
      selectedHourPrices.add(newselectedHourPrice!);
      if (newSearchStartPeriod != null) {
        searchStartPeriod = newSearchStartPeriod;
      } else {
        searchStartPeriod =
            Provider.of<CategoriesProvider>(context, listen: false)
                .getFirstHour;
      }
      if (newSearchEndPeriod != null) {
        searchEndPeriod = newSearchEndPeriod;
      } else {
        searchEndPeriod =
            Provider.of<CategoriesProvider>(context, listen: false)
                .getLastSearchHour;
      }
      selectedCourt = courtAvailableHours
          .firstWhere(
            (court) => court.hourPrices.any(
              (hourPrice) => hourPrice == selectedHourPrices.first,
            ),
          )
          .court;
    } else if (canMakeReservation) {
      if (isRecurrent == true) {
        selectedWeekday = getSFWeekday(DateTime.now().weekday);
      } else {
        selectedDate = DateTime.now();
      }
      selectedSport = newSelectedSport ??
          Provider.of<UserProvider>(context, listen: false)
              .user!
              .preferenceSport;
      searchStartPeriod =
          Provider.of<CategoriesProvider>(context, listen: false)
              .getFirstSearchHour;
      searchEndPeriod = Provider.of<CategoriesProvider>(context, listen: false)
          .getLastSearchHour;
      searchStoreAvailableHours(context);
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

  void searchStoreAvailableHours(BuildContext context) {
    if (store != null) {
      isLoading = true;
      notifyListeners();
      if (isRecurrent == true) {
        searchRecurrentMatches(context);
      } else {
        searchMatches(context);
      }
    }
  }

  void searchMatches(BuildContext context) {
    matchSearchRepo
        .searchCourts(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      selectedSport!.idSport,
      store!.city.cityId,
      selectedDate!,
      selectedDate!,
      searchStartPeriod!.hour,
      searchEndPeriod!.hour,
      store!.idStore,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Tuple2<List<AvailableDay>, List<AppMatch>> searchResult =
            matchSearchDecoder(context, response.responseBody!);
        List<AvailableDay> availableDays = searchResult.item1;

        courtAvailableHours =
            toCourtAvailableHours(availableDays, null, selectedDate!, store!);
        isLoading = false;
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login_signup',
              (Route<dynamic> route) => false,
            );
          },
          isHappy: false,
        );

        isLoading = false;
        notifyListeners();
      }
    });
  }

  void searchRecurrentMatches(BuildContext context) {
    recurrentMatchSearchRepo
        .searchRecurrentCourts(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      selectedSport!.idSport,
      store!.city.cityId,
      selectedWeekday.toString(),
      searchStartPeriod!.hourString,
      searchEndPeriod!.hourString,
      store!.idStore,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        List<AvailableDay> availableDays =
            recurrentMatchDecoder(response.responseBody!);
        courtAvailableHours = toCourtAvailableHours(
          availableDays,
          selectedWeekday,
          null,
          store!,
        );
        isLoading = false;
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login_signup',
              (Route<dynamic> route) => false,
            );
          },
          isHappy: false,
        );

        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void onTapHourPrice(Court court, HourPrice hourPrice) {
    if ((selectedCourt == null) ||
        (court.idStoreCourt != selectedCourt!.idStoreCourt)) {
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

  void onYesterday(BuildContext context) {
    if (isRecurrent == true) {
      selectedWeekday = lastWeekDay(selectedWeekday!);
    } else {
      selectedDate = selectedDate!.subtract(
        Duration(
          days: 1,
        ),
      );
    }
    searchStoreAvailableHours(context);

    notifyListeners();
  }

  void onTomorrow(BuildContext context) {
    if (isRecurrent == true) {
      selectedWeekday = nextWeekDay(selectedWeekday!);
    } else {
      selectedDate = selectedDate!.add(
        Duration(
          days: 1,
        ),
      );
    }
    searchStoreAvailableHours(context);

    notifyListeners();
  }

  void openDateSelectorModal(BuildContext context) {
    widgetForm = CalendarModal(
      allowMultiDates: false,
      dateRange: [selectedDate],
      onSubmit: (newDates) {
        pageStatus = PageStatus.OK;
        notifyListeners();
        if (newDates.length == 1) {
          selectedDate = newDates.first;
          searchStoreAvailableHours(context);
        }
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }
}
