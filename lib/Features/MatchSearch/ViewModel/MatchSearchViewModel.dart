import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableStore.dart';
import 'package:time_range/time_range.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/AvailableCourt.dart';
import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Region.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Model/StoreDay.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/CitySelectorModal.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/MatchSearchRepoImp.dart';
import '../View/CalendarModal.dart';
import '../View/TimeModal.dart';

class MatchSearchViewModel extends ChangeNotifier {
  final matchSearchRepo = MatchSearchRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;

  late String titleText;
  late Sport sportFilter;

  City? cityFilter;
  List<DateTime?> datesFilter = [];
  TimeRangeResult? timeFilter;

  bool hasUserSearched = false;

  final List<AvailableDay> availableDays = [];
  final List<AppMatch> openMatches = [];

  void initMatchSearchViewModel(BuildContext context, int sportId) {
    sportFilter = Provider.of<CategoriesProvider>(context, listen: false)
        .sports
        .firstWhere(
          (sport) => sport.idSport == sportId,
        );
    titleText = "Busca - ${sportFilter.description}";
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  AvailableHour? _selectedHour;
  AvailableHour? get selectedHour => _selectedHour;
  set selectedHour(AvailableHour? newHour) {
    _selectedHour = newHour;
    notifyListeners();
  }

  AvailableStore? _selectedStore;
  AvailableStore? get selectedStore => _selectedStore;
  set selectedStore(AvailableStore? newStore) {
    _selectedStore = newStore;
    notifyListeners();
  }

  AvailableDay? _selectedDay;
  AvailableDay? get selectedDay => _selectedDay;
  set selectedDay(AvailableDay? newDay) {
    _selectedDay = newDay;
    notifyListeners();
  }

  void onSelectedHour(AvailableDay avDay) {
    _selectedDay = avDay;
    _selectedStore = avDay.stores.first;
    _selectedHour = avDay.stores.first.availableHours.first;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  bool get canSearchMatch => datesFilter.isNotEmpty && cityFilter != null;

  void openCitySelectorModal(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    if (Provider.of<CategoriesProvider>(context, listen: false)
        .availableRegions
        .isEmpty) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .categoriesProviderRepo
          .getAvailableRegions()
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
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openDateSelectorModal(BuildContext context) {
    widgetForm = CalendarModal(
      dateRange: datesFilter,
      onSubmit: (newDates) => onSubmitDateFilter(newDates),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void onSubmitDateFilter(List<DateTime?> newDates) {
    datesFilter = newDates;
    closeModal();
  }

  void openTimeSelectorModal(BuildContext context) {
    widgetForm = TimeModal(
      timeRange: timeFilter,
      onSubmit: (newTimeFilter) => onSubmitTimeFilter(newTimeFilter),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  onSubmitTimeFilter(TimeRangeResult? newTimeFilter) {
    timeFilter = newTimeFilter;
    closeModal();
  }

  void searchCourts(context) {
    if (canSearchMatch) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      timeFilter ??= TimeRangeResult(
        const TimeOfDay(hour: 1, minute: 00),
        const TimeOfDay(
          hour: 23,
          minute: 00,
        ),
      );
      matchSearchRepo
          .searchCourts(
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        sportFilter.idSport,
        cityFilter!.cityId,
        datesFilter[0]!,
        datesFilter.length < 2 ? datesFilter[0]! : datesFilter[1]!,
        timeFilter!.start.format(context),
        timeFilter!.end.format(context),
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          hasUserSearched = true;
          setSearchMatchesResult(response.responseBody!);
          pageStatus = PageStatus.OK;
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

  void setSearchMatchesResult(String response) {
    availableDays.clear();
    openMatches.clear();

    List<Store> receivedStores = [];

    final responseBody = json.decode(response);
    final responseDates = responseBody['Dates'];
    final responseStores = responseBody['Stores'];
    final responseOpenMatches = responseBody['OpenMatches'];

    for (var store in responseStores) {
      receivedStores.add(
        Store.fromJson(
          store,
        ),
      );
    }

    for (var date in responseDates) {
      DateTime newDate = DateFormat('dd/MM/yyyy').parse(date["Date"]);
      List<AvailableStore> availableStores = [];
      for (var store in date["Stores"]) {
        Store newStore = receivedStores
            .firstWhere((recStore) => recStore.idStore == store["IdStore"]);
        List<AvailableHour> availableHours = [];
        for (var hour in store["Hours"]) {
          List<AvailableCourt> availableCourts = [];
          for (var court in hour["Courts"]) {
            availableCourts.add(
              AvailableCourt(
                court: newStore.courts.firstWhere((recCourt) =>
                    recCourt.idStoreCourt == court["IdStoreCourt"]),
                price: court["Price"],
              ),
            );
          }
          availableHours.add(
            AvailableHour(
              hour["TimeBegin"],
              hour["TimeFinish"],
              hour["TimeInteger"],
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
          day: newDate,
          stores: availableStores,
        ),
      );
    }
  }

  void goToMatch(BuildContext context, String matchUrl) {
    Navigator.pushNamed(context, '/match?id=$matchUrl');
  }

  goToOpenMatches() {}
}
