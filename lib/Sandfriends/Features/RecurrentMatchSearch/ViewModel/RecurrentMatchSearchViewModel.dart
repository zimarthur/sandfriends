import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/Repository/RecurrentMatchDecoder.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/View/WeekdayModal.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:time_range/time_range.dart';

import '../../../../Common/Components/Modal/CitySelectorModal.dart';
import '../../../../Common/Components/Modal/TimeModal.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/AvailableStore.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Model/Store.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../Court/Model/CourtAvailableHours.dart';
import '../Repository/RecurrentMatchSearchRepo.dart';

class RecurrentMatchSearchViewModel extends StandardScreenViewModel {
  final recurrentMatchSearchRepo = RecurrentMatchSearchRepo();

  late String titleText;
  late Sport selectedSport;

  City? cityFilter;
  List<int> datesFilter = [];
  TimeRangeResult? timeFilter;
  TimeRangeResult? defaultTimeFilter = TimeRangeResult(
    const TimeOfDay(hour: 6, minute: 00),
    const TimeOfDay(
      hour: 23,
      minute: 00,
    ),
  );

  bool hasUserSearched = false;
  bool get canSearchRecurrentMatch =>
      datesFilter.isNotEmpty && cityFilter != null;

  List<AvailableDay> availableDays = [];

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
      timeFilter ??= defaultTimeFilter;
      recurrentMatchSearchRepo
          .searchRecurrentCourts(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        selectedSport.idSport,
        cityFilter!.cityId,
        datesFilter.join(";"),
        timeFilter!.start.format(context),
        timeFilter!.end.format(context),
        null,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          hasUserSearched = true;
          availableDays = recurrentMatchDecoder(response.responseBody!);
          pageStatus = PageStatus.OK;
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
          if (response.responseStatus == NetworkResponseStatus.expiredToken) {
            canTapBackground = false;
          }
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      modalMessage = SFModalMessage(
        title: "Selecione uma cidade e uma data pra buscar os horários",
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
            title: response.responseTitle!,
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
      onReturn: () => closeModal(),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openDateSelectorModal(BuildContext context) {
    widgetForm = WeekdayModal(
      selectedWeekdays: datesFilter,
      onSelected: () {
        if (timeFilter != defaultTimeFilter) {
          openTimeSelectorModal(context);
        } else {
          searchRecurrentCourts(context);
        }
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openTimeSelectorModal(BuildContext context) {
    widgetForm = TimeModal(
      timeRange: timeFilter,
      onSubmit: (newTimeFilter) {
        onSubmitTimeFilter(newTimeFilter);
        searchRecurrentCourts(context);
      },
      themeColor: primaryLightBlue,
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void onSubmitTimeFilter(TimeRangeResult? newTimeFilter) {
    timeFilter = newTimeFilter;
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
          selectedDay!.weekday,
          null,
          store,
        ),
        'selectedHourPrice': selectedHour!.lowestHourPrice,
        'selectedDate': null,
        'selectedWeekday': selectedDay!.weekday,
        'selectedSport': selectedSport,
        'isRecurrent': true,
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
}
