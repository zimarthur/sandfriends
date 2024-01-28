import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableStore.dart';
import 'package:sandfriends/SharedComponents/Model/Hour.dart';
import 'package:time_range/time_range.dart';
import 'package:tuple/tuple.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/AvailableCourt.dart';
import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/CitySelectorModal.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../Court/Model/CourtAvailableHours.dart';
import '../../Court/Model/HourPrice.dart';
import '../Repository/MatchSearchDecoder.dart';
import '../Repository/MatchSearchRepoImp.dart';
import '../View/CalendarModal.dart';
import '../../../SharedComponents/View/Modal/TimeModal.dart';
import 'package:geolocator/geolocator.dart';

class MatchSearchViewModel extends ChangeNotifier {
  final matchSearchRepo = MatchSearchRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;
  bool canTapBackground = true;

  String get titleText => "Busca - ${currentCustomFilter.sport.description}";

  City? cityFilter;
  List<DateTime?> datesFilter = [];
  TimeRangeResult? timeFilter;
  TimeRangeResult? defaultTimeFilter = TimeRangeResult(
    const TimeOfDay(hour: 6, minute: 00),
    const TimeOfDay(
      hour: 23,
      minute: 00,
    ),
  );

  late CustomFilter defaultCustomFilter;
  late CustomFilter currentCustomFilter;

  bool hasUserSearched = false;

  List<AvailableDay> _availableDays = [];
  List<AvailableDay> get availableDays {
    if (currentCustomFilter.orderBy == OrderBy.distance) {
      for (var avDay in _availableDays) {
        avDay.stores.sort(
          (a, b) => a.store.distanceBetweenPlayer!
              .compareTo(b.store.distanceBetweenPlayer!),
        );
      }
    } else {
      for (var avDay in _availableDays) {
        avDay.stores.sort(
          (a, b) => a.availableHours
              .reduce((a, b) =>
                  a.lowestHourPrice.price < b.lowestHourPrice.price ? a : b)
              .lowestHourPrice
              .price
              .compareTo(
                b.availableHours
                    .reduce((a, b) =>
                        a.lowestHourPrice.price < b.lowestHourPrice.price
                            ? a
                            : b)
                    .lowestHourPrice
                    .price,
              ),
        );
      }
    }
    return _availableDays;
  }

  List<AppMatch> openMatches = [];

  bool get canSearchMatch => datesFilter.isNotEmpty && cityFilter != null;

  bool get customFilterHasChanged => defaultCustomFilter != currentCustomFilter;

  AvailableHour? selectedHour;
  AvailableStore? selectedStore;
  AvailableDay? selectedDay;

  void initMatchSearchViewModel(BuildContext context, int sportId) {
    defaultCustomFilter = CustomFilter(
        orderBy: OrderBy.price,
        sport: Provider.of<UserProvider>(context, listen: false)
            .user!
            .preferenceSport!);
    currentCustomFilter = CustomFilter.copyFrom(defaultCustomFilter);

    if (Provider.of<CategoriesProvider>(context, listen: false)
        .availableRegions
        .any(
          (region) => region.containsCity(
            Provider.of<UserProvider>(context, listen: false)
                .user!
                .city!
                .cityId,
          ),
        )) {
      cityFilter = Provider.of<UserProvider>(context, listen: false).user!.city;
    }
    Provider.of<UserProvider>(context, listen: false)
        .handlePositionPermission()
        .then((value) {
      if (value == true) {
        defaultCustomFilter.orderBy = OrderBy.distance;
        currentCustomFilter.orderBy = OrderBy.distance;
        notifyListeners();
      }
    });
  }

  void searchCourts(context) {
    if (canSearchMatch) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      timeFilter ??= defaultTimeFilter;
      matchSearchRepo
          .searchCourts(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        currentCustomFilter.sport.idSport,
        cityFilter!.cityId,
        datesFilter[0]!,
        datesFilter.length < 2 ? datesFilter[0]! : datesFilter[1]!,
        Provider.of<CategoriesProvider>(context, listen: false)
            .hours
            .firstWhere(
                (hour) => hour.hourString == timeFilter!.start.format(context))
            .hour,
        Provider.of<CategoriesProvider>(context, listen: false)
            .hours
            .firstWhere(
                (hour) => hour.hourString == timeFilter!.end.format(context))
            .hour,
        null,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          hasUserSearched = true;
          Tuple2<List<AvailableDay>, List<AppMatch>> searchResult =
              matchSearchDecoder(context, response.responseBody!);
          _availableDays = searchResult.item1;
          openMatches = searchResult.item2;
          pageStatus = PageStatus.OK;
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
          canTapBackground = false;

          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      modalMessage = SFModalMessage(
        message: "Selecione uma cidade e uma data pra buscar os horários",
        onTap: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        isHappy: true,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    }
  }

  void onSelectedHour(AvailableDay avDay) {
    selectedDay = avDay;
    selectedStore = avDay.stores.first;
    selectedHour = avDay.stores.first.availableHours.first;
    notifyListeners();
  }

  void goToCourt(BuildContext context, Store store) {
    Navigator.pushNamed(
      context,
      '/court',
      arguments: {
        'store': store,
        'availableCourts': toCourtAvailableHours(
          availableDays,
          null,
          selectedDay!.day,
          selectedStore!.store,
        ),
        'selectedHourPrice': selectedHour!.lowestHourPrice,
        'selectedDate': selectedDay!.day,
        'selectedWeekday': null,
        'selectedSport': currentCustomFilter.sport,
        'isRecurrent': false,
        'canMakeReservation': true,
        'searchStartPeriod': Provider.of<CategoriesProvider>(context,
                listen: false)
            .hours
            .firstWhere(
                (hour) => hour.hourString == timeFilter!.start.format(context)),
        'searchEndPeriod': Provider.of<CategoriesProvider>(context,
                listen: false)
            .hours
            .firstWhere(
                (hour) => hour.hourString == timeFilter!.end.format(context)),
      },
    );
  }

  void openCitySelectorModal(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    if (Provider.of<CategoriesProvider>(context, listen: false)
        .availableRegions
        .isEmpty) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .categoriesProviderRepo
          .getAvailableRegions(context)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<CategoriesProvider>(context, listen: false)
              .setAvailableRegions(response.responseBody!);

          displayCitySelector(context);
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage!,
            onTap: () => openCitySelectorModal(context),
            isHappy: false,
            buttonText: "Tentar novamente",
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      displayCitySelector(context);
    }
  }

  void displayCitySelector(BuildContext context) {
    widgetForm = CitySelectorModal(
      regions: Provider.of<CategoriesProvider>(context, listen: false)
          .availableRegions,
      onSelectedCity: (city) {
        cityFilter = city;
        pageStatus = PageStatus.OK;
        notifyListeners();
      },
      userCity: Provider.of<UserProvider>(context, listen: false).user!.city,
      onReturn: () => closeModal(),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openDateSelectorModal(BuildContext context) {
    widgetForm = CalendarModal(
      allowMultiDates: true,
      dateRange: datesFilter,
      onSubmit: (newDates) {
        onSubmitDateFilter(newDates);
        if (timeFilter != defaultTimeFilter) {
          openTimeSelectorModal(context);
        } else {
          searchCourts(context);
        }
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void onSubmitDateFilter(List<DateTime?> newDates) {
    datesFilter = newDates;
  }

  void openTimeSelectorModal(BuildContext context) {
    widgetForm = TimeModal(
      timeRange: timeFilter,
      onSubmit: (newTimeFilter) {
        onSubmitTimeFilter(newTimeFilter);
        searchCourts(context);
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void onSubmitTimeFilter(TimeRangeResult? newTimeFilter) {
    timeFilter = newTimeFilter;
  }

  void goToMatch(BuildContext context, String matchUrl) {
    Navigator.pushNamed(context, '/match/$matchUrl');
  }

  void goToOpenMatches() {}

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> goToSearchFilter(BuildContext context) async {
    Navigator.pushNamed(context, "/match_search_filter", arguments: {
      'defaultCustomFilter': defaultCustomFilter,
      'currentCustomFilter': currentCustomFilter,
      'selectedCityId': cityFilter,
    }).then((newFilter) {
      if (newFilter is CustomFilter) {
        bool needsUpdate = false;
        if (currentCustomFilter.sport.idSport != newFilter.sport.idSport) {
          needsUpdate = true;
        }
        currentCustomFilter = newFilter;
        if (needsUpdate) {
          searchCourts(context);
        }
        notifyListeners();
      }
    });
  }
}
