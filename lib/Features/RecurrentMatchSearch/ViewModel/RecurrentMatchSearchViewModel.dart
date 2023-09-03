import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/RecurrentMatchSearch/View/WeekdayModal.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:time_range/time_range.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AvailableCourt.dart';
import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/AvailableHour.dart';
import '../../../SharedComponents/Model/AvailableStore.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Hour.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/CitySelectorModal.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../SharedComponents/View/Modal/TimeModal.dart';
import '../../../Utils/PageStatus.dart';
import '../../Court/Model/CourtAvailableHours.dart';
import '../../Court/Model/HourPrice.dart';
import '../Repository/RecurrentMatchSearchRepoImp.dart';

class RecurrentMatchSearchViewModel extends ChangeNotifier {
  final recurrentMatchSearchRepo = RecurrentMatchSearchRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;

  late String titleText;
  late Sport selectedSport;

  City? cityFilter;
  List<int> datesFilter = [];
  TimeRangeResult? timeFilter;

  bool hasUserSearched = false;
  bool get canSearchRecurrentMatch =>
      datesFilter.isNotEmpty && cityFilter != null;

  final List<AvailableDay> availableDays = [];

  AvailableHour? selectedHour;
  AvailableStore? selectedStore;
  AvailableDay? selectedDay;

  void initRecurrentMatchSearchViewModel(BuildContext context, int sportId) {
    selectedSport = Provider.of<CategoriesProvider>(context, listen: false)
        .sports
        .firstWhere(
          (sport) => sport.idSport == sportId,
        );
    titleText = "Busca Mensalista - ${selectedSport.description}";
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
  }

  void searchRecurrentCourts(context) {
    if (canSearchRecurrentMatch) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      timeFilter ??= TimeRangeResult(
        const TimeOfDay(hour: 6, minute: 00),
        const TimeOfDay(
          hour: 23,
          minute: 00,
        ),
      );
      recurrentMatchSearchRepo
          .searchRecurrentCourts(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        selectedSport.idSport,
        cityFilter!.cityId,
        datesFilter.join(";"),
        timeFilter!.start.format(context),
        timeFilter!.end.format(context),
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          hasUserSearched = true;
          setSearchRecurrentCourtsResult(response.responseBody!);
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

  void setSearchRecurrentCourtsResult(String response) {
    availableDays.clear();

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
                    (recCourt) =>
                        recCourt.idStoreCourt == court["IdStoreCourt"],
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
      themeColor: primaryLightBlue,
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
    widgetForm = WeekdayModal(
      selectedWeekdays: datesFilter,
      onSelected: () => closeModal(),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openTimeSelectorModal(BuildContext context) {
    widgetForm = TimeModal(
      timeRange: timeFilter,
      onSubmit: (newTimeFilter) => onSubmitTimeFilter(newTimeFilter),
      themeColor: primaryLightBlue,
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void onSubmitTimeFilter(TimeRangeResult? newTimeFilter) {
    timeFilter = newTimeFilter;
    closeModal();
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
        'availableCourts': toCourtAvailableHours(),
        'selectedHourPrice': selectedHour!.lowestHourPrice,
        'selectedDate': null,
        'selectedWeekday': selectedDay!.weekday,
        'selectedSport': selectedSport,
        'isRecurrent': true,
      },
    );
  }

  List<CourtAvailableHours> toCourtAvailableHours() {
    List<CourtAvailableHours> courtAvailableHours = [];
    List<AvailableHour> filteredHours = availableDays
        .firstWhere((avDay) => avDay.day == selectedDay!.day)
        .stores
        .firstWhere(
          (avStore) => avStore.store.idStore == selectedStore!.store.idStore,
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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
