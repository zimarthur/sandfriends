import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Region.dart';
import '../../../SharedComponents/Model/Sport.dart';
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

  final List<StoreDay> storeDays = [];
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
    storeDays.clear();
    openMatches.clear();

    List<Court> receivedCourts = [];

    final responseBody = json.decode(response);
    final responseDates = responseBody['Dates'];
    final responseStores = responseBody['Stores'];
    final responseCourts = responseBody['Courts'];
    final responseOpenMatches = responseBody['OpenMatches'];

    for (var court in responseCourts) {
      receivedCourts.add(
        Court.fromJson(
          court,
        ),
      );
    }

    for (var date in responseDates) {}

    // var newStore;
    // int courtIndexTotal = 0;
    // for (int dateIndex = 0; dateIndex < responseDates.length; dateIndex++) {
    //   Map firstLevel = responseDates[dateIndex];
    //   for (int storeIndex = 0;
    //       storeIndex < firstLevel['Places'].length;
    //       storeIndex++) {
    //     Map secondLevel = firstLevel['Places'][storeIndex];
    //     Provider.of<StoreProvider>(context, listen: false)
    //         .stores
    //         .forEach((store) {
    //       if (store.idStore == secondLevel['IdStore']) {
    //         newStore = store;
    //       }
    //     });
    //     StoreDay storeDay = StoreDay(
    //       store: newStore,
    //       day: firstLevel['Date'],
    //     );

    //     for (int availableHoursIndex = 0;
    //         availableHoursIndex < secondLevel['Available'].length;
    //         availableHoursIndex++) {
    //       Map thirdLevel = secondLevel['Available'][availableHoursIndex];
    //       for (int courtIndex = 0;
    //           courtIndex < thirdLevel['Courts'].length;
    //           courtIndex++) {
    //         Map fourthLevel = thirdLevel['Courts'][courtIndex];

    //         bool newcourt = false;
    //         if (storeDay.courts.isEmpty ||
    //             (storeDay.courts.any((court) =>
    //                     court.idStoreCourt == fourthLevel['IdStoreCourt']) ==
    //                 false)) {
    //           newcourt = true;
    //         }
    //         if (newcourt) {
    //           Provider.of<CourtProvider>(context, listen: false)
    //               .courts
    //               .forEach((court) {
    //             if (court.idStoreCourt == fourthLevel['IdStoreCourt']) {
    //               storeDay.courts.add(court);
    //             }
    //           });
    //         }
    //         for (int i = 0; i < storeDay.courts.length; i++) {
    //           if (storeDay.courts[i].idStoreCourt ==
    //               fourthLevel['IdStoreCourt']) {
    //             storeDay.courts[i].availableHours.add(CourtAvailableHour(
    //                 thirdLevel['TimeBegin'],
    //                 thirdLevel['TimeInteger'],
    //                 thirdLevel['TimeFinish'],
    //                 fourthLevel['Price']));
    //           }
    //         }
    //       }
    //     }
    //     Provider.of<MatchProvider>(context, listen: false)
    //         .addStoreDay(storeDay);
    //   }
    // }

    // for (int i = 0; i < responseOpenMatches.length; i++) {
    //   Provider.of<MatchProvider>(context, listen: false)
    //       .addOpenMatch(responseOpenMatches[i]);
    // }
  }
}
