import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/TimeModal.dart';
import 'package:sandfriends/Common/Features/Court/View/PhotoViewModal.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/CourtReservationModal.dart';
import 'package:sandfriends/Common/Model/OperationDayUser.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Providers/Environment/Environment.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Features/Court/Model/CourtAvailableHours.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:time_range/time_range.dart';
import 'package:tuple/tuple.dart';
import '../../../Model/AppMatch/AppMatchUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Model/AvailableDay.dart';
import '../../../Model/Court.dart';
import '../../../Model/Hour.dart';
import '../../../Model/Sport.dart';
import '../../../Model/Store/StoreComplete.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/Modal/SFModalMessage.dart';
import '../../../Providers/Overlay/OverlayProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../../../../Sandfriends/Features/MatchSearch/Repository/MatchSearchDecoder.dart';
import '../../../../Sandfriends/Features/MatchSearch/Repository/MatchSearchRepo.dart';
import '../../../../Sandfriends/Features/MatchSearch/View/CalendarModal.dart';
import '../../../../Sandfriends/Features/RecurrentMatchSearch/Repository/RecurrentMatchDecoder.dart';
import '../../../../Sandfriends/Features/RecurrentMatchSearch/Repository/RecurrentMatchSearchRepo.dart';
import '../Repository/CourtRepo.dart';

class CourtViewModel extends CheckoutViewModel {
  final courtRepo = CourtRepo();
  final matchSearchRepo = MatchSearchRepo();
  final recurrentMatchSearchRepo = RecurrentMatchSearchRepo();

  bool isLoading = false;

  int selectedPhotoIndex = 0;
  StoreUser? store;
  List<CourtAvailableHours> courtAvailableHours = [];
  List<HourPriceUser> selectedHourPrices = [];
  Court? selectedCourt;
  DateTime? selectedDate;
  int? selectedWeekday;
  late bool canMakeReservation;
  Hour? searchStartPeriod;
  Hour? searchEndPeriod;

  TimeRangeResult? get timeFilter {
    if (searchStartPeriod == null || searchEndPeriod == null) {
      return null;
    }
    return TimeRangeResult(
      TimeOfDay(hour: searchStartPeriod!.hour, minute: 00),
      TimeOfDay(
        hour: searchEndPeriod!.hour,
        minute: 00,
      ),
    );
  }

  Sport? selectedSport;

  bool isLoadingOperationDays = true;

  int currentAnimation = 0;
  int animationStep = 50;
  int animationEndMiliSeconds = 4000;

  void setCourtPhotoModal() {
    widgetForm = PhotoViewModal(
      imagesUrl: store!.photos,
      onClose: () => closeModal(),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void setCourtReservationModal(BuildContext context) {
    Provider.of<OverlayProvider>(context, listen: false).addOverlayWidget(
      CourtReservationModal(
        onClose: () => clearOverlays(),
      ),
    );
  }

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
    StoreUser? newStore,
    String newStoreUrl,
    List<CourtAvailableHours>? newCourtAvailableHours,
    HourPriceUser? newselectedHourPrice,
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

      final response = await courtRepo.getStore(context, newStoreUrl);

      if (response.responseStatus == NetworkResponseStatus.success) {
        store = StoreUser.fromJson(json.decode(response.responseBody!));
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        canTapBackground = false;
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
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
              .user
              ?.preferenceSport ??
          Provider.of<CategoriesProvider>(context, listen: false).sessionSport;
      searchStartPeriod =
          Provider.of<CategoriesProvider>(context, listen: false)
              .getFirstSearchHour;
      searchEndPeriod = Provider.of<CategoriesProvider>(context, listen: false)
          .getLastSearchHour;
      searchStoreAvailableHours(context);
    }

    notifyListeners();
    loadStoreOperationDays(context);
  }

  void loadStoreOperationDays(BuildContext context) {
    courtRepo.getStoreOperationDays(context, store!.idStore).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        List<dynamic> responseBody = json.decode(response.responseBody!);

        store!.operationDays = responseBody
            .map(
              (opDay) => OperationDayUser.fromJson(
                opDay,
                Provider.of<CategoriesProvider>(context, listen: false).hours,
              ),
            )
            .toList();
      }

      isLoadingOperationDays = false;
      notifyListeners();
    });
  }

  void onSelectedPhotoChanged(int newIndex) {
    selectedPhotoIndex = newIndex;
    notifyListeners();
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
      Provider.of<UserProvider>(context, listen: false).user?.accessToken,
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
        Tuple2<List<AvailableDay>, List<AppMatchUser>> searchResult =
            matchSearchDecoder(context, response.responseBody!);
        List<AvailableDay> availableDays = searchResult.item1;

        courtAvailableHours =
            toCourtAvailableHours(availableDays, null, selectedDate!, store!);
        isLoading = false;
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
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
          title: response.responseTitle!,
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

  void onTapHourPrice(Court court, HourPriceUser hourPrice) {
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
        const Duration(
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
        const Duration(
          days: 1,
        ),
      );
    }
    searchStoreAvailableHours(context);

    notifyListeners();
  }

  void openDateSelectorModal(BuildContext context) {
    Provider.of<OverlayProvider>(context, listen: false).addOverlayWidget(
      CalendarModal(
        allowMultiDates: false,
        dateRange: [selectedDate],
        onSubmit: (newDates) {
          removeLastOverlay();
          if (newDates.length == 1) {
            selectedDate = newDates.first;
            searchStoreAvailableHours(context);
          }
        },
      ),
    );
  }

  void openTimeSelectorModal(BuildContext context) {
    Provider.of<OverlayProvider>(context, listen: false).addOverlayWidget(
      TimeModal(
        timeRange: timeFilter,
        onSubmit: (timeRange) {
          if (timeRange == null) {
            return;
          }
          searchStartPeriod =
              Provider.of<CategoriesProvider>(context, listen: false)
                  .hours
                  .firstWhere((hour) => hour.hour == timeRange.start.hour);
          searchEndPeriod =
              Provider.of<CategoriesProvider>(context, listen: false)
                  .hours
                  .firstWhere((hour) => hour.hour == timeRange.end.hour);
          notifyListeners();
          removeLastOverlay();
        },
      ),
    );
  }
}
