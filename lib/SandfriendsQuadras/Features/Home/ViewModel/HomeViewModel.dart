import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Home/Model/CourtOccupation.dart';
import 'package:sandfriends_web/Features/Home/Model/FilterCourt.dart';
import 'package:sandfriends_web/Features/Home/Model/HourMatch.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppNotification.dart';
import 'package:sandfriends_web/SharedComponents/Model/Reward.dart';
import 'package:sandfriends_web/SharedComponents/Model/StoreWorkingHours.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import 'package:tuple/tuple.dart';

import '../../../SharedComponents/Model/Court.dart';
import '../../../SharedComponents/Model/Hour.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../Menu/ViewModel/MenuProvider.dart';

class HomeViewModel extends ChangeNotifier {
  List<AppNotification> notifications = [];
  List<Reward> rewards = [];
  List<Hour> availableHours = [];
  List<Hour> workingHours = [];
  List<AppMatch> matches = [];
  List<Court> courts = [];
  List<CourtOccupation> courtsOccupation = [];
  late Store store;

  late double averageOccupation;

  late Hour displayedHour;

  bool storeClosedToday = false;

  bool filterNow = false;
  List<FilterCourt> filterCourts = [];

  bool get hasAnyFilter {
    return filterNow ||
        filterCourts.any((filterCourt) => filterCourt.isFiltered);
  }

  void onTapFilterNow() {
    filterNow = !filterNow;
    notifyListeners();
  }

  void onTapFilterCourt(FilterCourt courtFilter) {
    filterCourts
        .firstWhere((filterCourt) =>
            filterCourt.court.idStoreCourt == courtFilter.court.idStoreCourt)
        .isFiltered = !courtFilter.isFiltered;
    notifyListeners();
  }

  void clearFilter() {
    filterNow = false;
    filterCourts.clear();
    for (var court in courts) {
      filterCourts.add(
        FilterCourt(
          court: court,
          isFiltered: false,
        ),
      );
    }
    notifyListeners();
  }

  void setViewModel(
    BuildContext context,
  ) {
    store = Provider.of<DataProvider>(context, listen: false).store!;
    availableHours =
        Provider.of<DataProvider>(context, listen: false).availableHours;
    setWorkingHours(context);

    displayedHour = availableHours.firstWhere((hour) =>
        DateTime.now().hour == hour.hour ||
        (DateTime.now().hour == 0 && hour.hour == 24));
    notifications =
        Provider.of<DataProvider>(context, listen: false).notifications;
    courts = Provider.of<DataProvider>(context, listen: false).courts;
    matches = Provider.of<DataProvider>(context, listen: false)
        .matches
        .where((match) => (areInTheSameDay(match.date, DateTime.now())))
        .toList();
    setOccupationValues();
    rewards = Provider.of<DataProvider>(context, listen: false)
        .rewards
        .where((reward) => areInTheSameDay(reward.claimedDate, DateTime.now()))
        .toList();
    notifyListeners();
  }

  void initHomeScreen(BuildContext context) {
    setViewModel(context);
    for (var court in courts) {
      filterCourts.add(
        FilterCourt(
          court: court,
          isFiltered: false,
        ),
      );
    }
    if (workingHours.any((hour) => hour.hour == DateTime.now().hour)) {
      filterNow = true;
    }
    notifyListeners();
  }

  void updateViewModel(BuildContext context) async {
    await Provider.of<MenuProvider>(context, listen: false)
        .updateDataProvider(context);
    setViewModel(context);
  }

  void setWorkingHours(BuildContext context) {
    if (Provider.of<DataProvider>(context, listen: false).storeWorkingDays ==
        null) {
      workingHours = availableHours;
    } else {
      final todayWorkingDay = Provider.of<DataProvider>(context, listen: false)
          .storeWorkingDays!
          .firstWhere(
            (workingDay) =>
                workingDay.weekday == getSFWeekday(DateTime.now().weekday),
          );
      if (todayWorkingDay.isEnabled) {
        workingHours = availableHours
            .where((hour) =>
                hour.hour >= todayWorkingDay.startingHour!.hour &&
                hour.hour < todayWorkingDay.endingHour!.hour)
            .toList();
      } else {
        workingHours = availableHours;
      }
    }
  }

  void setOccupationValues() {
    courtsOccupation.clear();

    for (var court in courts) {
      int hoursPlayed = matches
          .where((match) => match.court.idStoreCourt == court.idStoreCourt)
          .toList()
          .fold(
              0,
              (previousValue, element) =>
                  previousValue + element.matchDuration);

      courtsOccupation.add(
        CourtOccupation(
          court: court,
          occupationPercentage: hoursPlayed / workingHours.length,
        ),
      );
    }
    if (courts.isEmpty) {
      averageOccupation = 0;
    } else {
      averageOccupation = courtsOccupation.fold(
              0.0,
              (previousValue, element) =>
                  previousValue + element.occupationPercentage) /
          courtsOccupation.length;
    }
  }

  void increaseHour() {
    displayedHour = availableHours
        .firstWhere((hour) => hour.hour == displayedHour.hour + 1);
    notifyListeners();
  }

  void decreaseHour() {
    displayedHour = availableHours
        .firstWhere((hour) => hour.hour == displayedHour.hour - 1);
    notifyListeners();
  }

  double get todaysProfit =>
      matches.fold(0, (previousValue, element) => previousValue + element.cost);

  List<AppMatch> get matchesOnDisplayesHour {
    List<AppMatch> filteredMatches = [];
    filteredMatches = matches
        .where((match) =>
            (match.startingHour.hour == displayedHour.hour) ||
            (match.startingHour.hour < displayedHour.hour &&
                match.endingHour.hour > displayedHour.hour))
        .toList();
    return filteredMatches;
  }

  List<HourMatch> get hourMatches {
    List<HourMatch> hourMatchesList = [];
    List<int> filteredIdStoreCourts = filterCourts
        .where((filteredCourt) => filteredCourt.isFiltered)
        .map((filteredCourt) => filteredCourt.court.idStoreCourt!)
        .toList();
    List<AppMatch> filteredMatches = filteredIdStoreCourts.isEmpty
        ? matches
        : matches
            .where(
              (match) => filteredIdStoreCourts.contains(
                match.court.idStoreCourt,
              ),
            )
            .toList();

    for (var hour in workingHours) {
      if (filterNow == false ||
          (filterNow && hour.hour == DateTime.now().hour)) {
        hourMatchesList.add(
          HourMatch(
            hour: hour,
            matches: filteredMatches
                .where((match) =>
                    (match.startingHour.hour == hour.hour) ||
                    (match.startingHour.hour < hour.hour &&
                        match.endingHour.hour > hour.hour))
                .toList(),
          ),
        );
      }
    }
    return hourMatchesList;
  }

  bool get isLowestHour =>
      displayedHour.hour ==
      availableHours.reduce((a, b) => a.hour < b.hour ? a : b).hour;

  bool get isHighestHour =>
      displayedHour.hour ==
      availableHours.reduce((a, b) => a.hour > b.hour ? a : b).hour;

  String get welcomeTitle {
    int hourNow = DateTime.now().hour;
    if (hourNow < 12) {
      return "Bom dia, ${store.name}!";
    } else if (hourNow < 18) {
      return "Boa tarde, ${store.name}!";
    } else {
      return "Boa noite, ${store.name}!";
    }
  }

  bool needsOnboarding(BuildContext context) {
    if (courtsSet(context) &&
        logoSet(context) &&
        photosSet(context) &&
        storeDescriptionSet(context)) {
      return false;
    } else {
      return true;
    }
  }

  bool courtsSet(BuildContext context) {
    if (Provider.of<DataProvider>(context, listen: false).courts.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool logoSet(BuildContext context) {
    return Provider.of<DataProvider>(context, listen: false).store!.logo !=
        null;
  }

  bool photosSet(BuildContext context) {
    return Provider.of<DataProvider>(context, listen: false)
            .store!
            .photos
            .length >=
        2;
  }

  bool storeDescriptionSet(BuildContext context) {
    if (Provider.of<DataProvider>(context, listen: false).store!.description !=
            null &&
        Provider.of<DataProvider>(context, listen: false)
            .store!
            .description!
            .isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
