import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Common/Model/AppMatch.dart';
import '../../../../Common/Model/AppRecurrentMatch.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/StoreWorkingDay.dart';
import '../../Menu/ViewModel/DataProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../Players/Repository/PlayersRepo.dart';
import '../Model/CalendarDailyCourtMatch.dart';
import '../Model/DayMatch.dart';
import '../Repository/CalendarRepo.dart';
import '../View/Web/Modal/Match/CourtsAvailabilityWidget.dart';
import '../View/Web/Modal/Match/MatchCancelWidget.dart';
import '../View/Web/Modal/Match/MatchDetailsWidget.dart';
import '../View/Web/Modal/RecurrentMatch/RecurrentCourtsAvailabilityWidget.dart';
import '../View/Web/Modal/RecurrentMatch/RecurrentMatchCancelWidget.dart';
import '../View/Web/Modal/RecurrentMatch/RecurrentMatchDetailsWidget.dart';

class CalendarViewModel extends ChangeNotifier {
  final calendarRepo = CalendarRepo();
  final playersRepo = PlayersRepo();

  List<Court> courts = [];
  List<StoreWorkingDay> storeWorkingDays = [];
  List<Hour> availableHours = [];
  List<AppMatch> matches = [];
  List<AppRecurrentMatch> recurrentMatches = [];
  late DateTime matchesStartDate;
  late DateTime matchesEndDate;
  bool isMobile = false;

  TextEditingController cancelMatchReasonController = TextEditingController();
  TextEditingController cancelRecurrentMatchReasonController =
      TextEditingController();

  final verticalController = ScrollController();
  final horizontalController = ScrollController();

  void initCalendarViewModel(BuildContext context, bool initIsMobile) {
    isMobile = initIsMobile;
    initTabs();
    Provider.of<MenuProvider>(context, listen: false).isDrawerExpanded = false;
    courts = Provider.of<DataProvider>(context, listen: false).courts;
    storeWorkingDays =
        Provider.of<DataProvider>(context, listen: false).storeWorkingDays !=
                null
            ? Provider.of<DataProvider>(context, listen: false)
                .storeWorkingDays!
                .map((workingDay) => StoreWorkingDay.copyFrom(workingDay))
                .toList()
            : [];

    availableHours =
        Provider.of<DataProvider>(context, listen: false).availableHours;
    matches = Provider.of<DataProvider>(context, listen: false)
        .allMatches
        .map((match) => AppMatch.copyWith(match))
        .toList();

    recurrentMatches = Provider.of<DataProvider>(context, listen: false)
        .recurrentMatches
        .map((recMatch) => AppRecurrentMatch.copyWith(recMatch))
        .toList();
    matchesStartDate =
        Provider.of<DataProvider>(context, listen: false).matchesStartDate;
    matchesEndDate =
        Provider.of<DataProvider>(context, listen: false).matchesEndDate;
    notifyListeners();
  }

  PeriodType _periodType = PeriodType.Daily;
  PeriodType get periodType => _periodType;
  set periodType(PeriodType newValue) {
    _periodType = newValue;
    notifyListeners();
  }

  CalendarType _calendarType = CalendarType.Match;
  CalendarType get calendarType => _calendarType;
  void setCalendarType(CalendarType newCalendarType) {
    _calendarType = newCalendarType;
    notifyListeners();
  }

  void initTabs() {
    tabItems = [
      SFTabItem(
        name: "Partidas",
        onTap: (newTab) {
          setCalendarType(CalendarType.Match);
          setSelectedTab(newTab);
        },
        displayWidget: Container(),
      ),
      SFTabItem(
        name: "Mensalistas",
        onTap: (newTab) {
          setCalendarType(CalendarType.RecurrentMatch);
          setSelectedWeekday(getSFWeekday(selectedDay.weekday));
          setSelectedTab(newTab);
        },
        displayWidget: Container(),
      ),
    ];
    _selectedTab = tabItems.first;
    notifyListeners();
  }

  List<SFTabItem> tabItems = [];

  SFTabItem _selectedTab =
      SFTabItem(name: "", displayWidget: Container(), onTap: (a) {});
  SFTabItem get selectedTab => _selectedTab;
  void setSelectedTab(SFTabItem newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }

  int _selectedWeekday = getSFWeekday(DateTime.now().weekday);
  int get selectedWeekday => _selectedWeekday;
  void setSelectedWeekday(int newValue) {
    _selectedWeekday = newValue;
    notifyListeners();
  }

  void increaseOneDay(BuildContext context) {
    setSelectedDay(
      context,
      selectedDay.add(
        Duration(
          days: 1,
        ),
      ),
    );
  }

  void decreaseOneDay(BuildContext context) {
    setSelectedDay(
      context,
      selectedDay.subtract(
        Duration(
          days: 1,
        ),
      ),
    );
  }

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  void setSelectedDay(BuildContext context, DateTime newSelectedDay) {
    setSelectedWeekday(getSFWeekday(newSelectedDay.weekday));
    setShowHourInfo(value: false);
    if (newSelectedDay.isAfter(matchesEndDate) ||
        newSelectedDay.isBefore(matchesStartDate)) {
      Provider.of<MenuProvider>(context, listen: false).setModalLoading();
      calendarRepo
          .updateMatchesList(
              context,
              Provider.of<DataProvider>(context, listen: false)
                  .loggedAccessToken,
              newSelectedDay)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          matches.clear();
          for (var match in responseBody['Matches']) {
            matches.add(
              AppMatch.fromJson(
                match,
                Provider.of<DataProvider>(context, listen: false)
                    .availableHours,
                Provider.of<DataProvider>(context, listen: false)
                    .availableSports,
              ),
            );
          }
          matchesStartDate =
              DateFormat("dd/MM/yyyy").parse(responseBody['MatchesStartDate']);
          matchesEndDate =
              DateFormat("dd/MM/yyyy").parse(responseBody['MatchesEndDate']);
          Provider.of<MenuProvider>(context, listen: false).closeModal();
          _selectedDay = newSelectedDay;
          notifyListeners();
        } else if (response.responseStatus ==
            NetworkResponseStatus.expiredToken) {
          Provider.of<MenuProvider>(context, listen: false).logout(context);
        } else {
          Provider.of<MenuProvider>(context, listen: false)
              .setMessageModalFromResponse(response);
        }
      });
    } else {
      _selectedDay = newSelectedDay;
      notifyListeners();
    }
  }

  List<DateTime> get selectedWeek {
    List<DateTime> days = [];
    DateTime dayStart;
    DateTime dayEnd;
    if (isMobile) {
      dayStart = _selectedDay.subtract(Duration(days: 3));
      dayEnd = _selectedDay.add(Duration(days: 3));
    } else {
      dayStart = _selectedDay
          .subtract(Duration(days: getSFWeekday(_selectedDay.weekday)));
      dayEnd = _selectedDay
          .add(Duration(days: 6 - getSFWeekday(_selectedDay.weekday)));
    }
    for (int i = 0; i <= dayEnd.difference(dayStart).inDays; i++) {
      days.add(dayStart.add(Duration(days: i)));
    }
    return days;
  }

  List<Hour> workingHoursFromDay(int weekDay) {
    if (storeWorkingDays.isEmpty) {
      return [];
    }
    StoreWorkingDay storeWorkingDay = storeWorkingDays
        .firstWhere((storeWorkingDay) => storeWorkingDay.weekday == weekDay);
    if (!storeWorkingDay.isEnabled) {
      return [];
    }
    return availableHours
        .where((hour) =>
            hour.hour >= storeWorkingDay.startingHour!.hour &&
            hour.hour < storeWorkingDay.endingHour!.hour)
        .toList();
  }

  List<Hour> get selectedDayWorkingHours {
    if (calendarType == CalendarType.Match) {
      return workingHoursFromDay(getSFWeekday(selectedDay.weekday));
    } else {
      return workingHoursFromDay(selectedWeekday);
    }
  }

  String get calendarDayTitle {
    if (calendarType == CalendarType.Match) {
      return "dia\n${DateFormat('dd/MM').format(selectedDay)}";
    } else {
      return weekdayRecurrent[selectedWeekday];
    }
  }

  List<CalendarDailyCourtMatch> get selectedDayMatchesMobile {
    List<CalendarDailyCourtMatch> selectedDayMatches = [];
    List<DayMatch> dayMatches = [];
    for (var court in courts) {
      dayMatches.clear();
      List<AppMatch> filteredMatches = matches
          .where((match) =>
              match.court.idStoreCourt == court.idStoreCourt &&
              areInTheSameDay(match.date, selectedDay))
          .toList();
      for (var hour in selectedDayWorkingHours) {
        AppMatch? match;
        AppRecurrentMatch? recMatch;
        List<AppMatch> concurrentMatches = [];
        bool hasMatch = filteredMatches.any((element) =>
            element.startingHour == hour ||
            (element.startingHour.hour < hour.hour &&
                element.endingHour.hour > hour.hour));
        if (hasMatch) {
          concurrentMatches = filteredMatches
              .where((element) =>
                  element.startingHour == hour ||
                  (element.startingHour.hour < hour.hour &&
                      element.endingHour.hour > hour.hour))
              .toList();
        }

        DayMatch dayMatch = DayMatch(startingHour: hour);

        if (concurrentMatches.any((match) =>
            !match.isFromRecurrentMatch && match.canceled == false)) {
          dayMatch.match = AppMatch.copyWith(concurrentMatches.firstWhere(
              (match) =>
                  !match.isFromRecurrentMatch && match.canceled == false));
        } else if (recurrentMatches.any((recMatch) =>
            recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
            recMatch.startingHour == hour &&
            recMatch.court.idStoreCourt == court.idStoreCourt)) {
          {
            recMatch = recurrentMatches.firstWhere((recMatch) =>
                recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
                recMatch.startingHour == hour &&
                recMatch.court.idStoreCourt == court.idStoreCourt);
            if (selectedDay.isAfter(recMatch.creationDate)) {
              bool hasToCheckForCanceledMatches = recMatch.blocked ||
                  (!recMatch.blocked &&
                      selectedDay.isBefore(recMatch.validUntil!));
              if (hasToCheckForCanceledMatches) {
                if (concurrentMatches.any((match) =>
                    match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                  if (concurrentMatches
                      .firstWhere((match) =>
                          match.idRecurrentMatch == recMatch!.idRecurrentMatch)
                      .canceled) {
                    recMatch = null;
                  } else {
                    dayMatch.recurrentMatch =
                        AppRecurrentMatch.copyWith(recMatch);
                  }
                } else {
                  dayMatch.recurrentMatch =
                      AppRecurrentMatch.copyWith(recMatch);
                }
              } else {
                dayMatch.recurrentMatch = AppRecurrentMatch.copyWith(recMatch);
              }
            } else {
              dayMatch.recurrentMatch = null;
            }
            if (dayMatch.recurrentMatch != null) {
              if (concurrentMatches.any((match) =>
                  match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                dayMatch.match = AppMatch.copyWith(concurrentMatches.firstWhere(
                    (match) =>
                        match.idRecurrentMatch == recMatch!.idRecurrentMatch));
              }
            }
          }
        }
        dayMatches.add(dayMatch);
      }

      selectedDayMatches.add(
        CalendarDailyCourtMatch(
          court: court,
          dayMatches: dayMatches
              .map((dayMatch) => DayMatch.copyWith(dayMatch))
              .toList(),
        ),
      );
    }
    return selectedDayMatches;
  }

  List<CalendarDailyCourtMatch> get selectedDayMatches {
    List<CalendarDailyCourtMatch> selectedDayMatches = [];
    List<DayMatch> dayMatches = [];
    int jumpToHour = -1;
    if (calendarType == CalendarType.Match) {
      for (var court in courts) {
        dayMatches.clear();
        jumpToHour = -1;
        List<AppMatch> filteredMatches = matches
            .where((match) =>
                match.court.idStoreCourt == court.idStoreCourt &&
                areInTheSameDay(match.date, selectedDay))
            .toList();
        for (var hour in selectedDayWorkingHours) {
          AppMatch? match;
          AppRecurrentMatch? recMatch;
          List<AppMatch> concurrentMatches = [];
          bool hasMatch =
              filteredMatches.any((element) => element.startingHour == hour);
          if (hasMatch) {
            concurrentMatches = filteredMatches
                .where((element) => element.startingHour == hour)
                .toList();
          }
          if (concurrentMatches.any((match) =>
              !match.isFromRecurrentMatch && match.canceled == false)) {
            match = AppMatch.copyWith(concurrentMatches.firstWhere((match) =>
                !match.isFromRecurrentMatch && match.canceled == false));
            jumpToHour = match.endingHour.hour;
          } else if (recurrentMatches.any((recMatch) =>
              recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
              recMatch.startingHour == hour &&
              recMatch.court.idStoreCourt == court.idStoreCourt)) {
            recMatch = recurrentMatches.firstWhere((recMatch) =>
                recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
                recMatch.startingHour == hour &&
                recMatch.court.idStoreCourt == court.idStoreCourt);
            if (selectedDay.isAfter(recMatch.creationDate)) {
              bool hasToCheckForCanceledMatches = recMatch.blocked ||
                  (!recMatch.blocked &&
                      selectedDay.isBefore(recMatch.validUntil!));
              if (hasToCheckForCanceledMatches) {
                if (concurrentMatches.any((match) =>
                    match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                  if (concurrentMatches
                      .firstWhere((match) =>
                          match.idRecurrentMatch == recMatch!.idRecurrentMatch)
                      .canceled) {
                    recMatch = null;
                  } else {
                    recMatch = AppRecurrentMatch.copyWith(recMatch);
                    jumpToHour = recMatch.endingHour.hour;
                  }
                }
              } else {
                recMatch = AppRecurrentMatch.copyWith(recMatch);
                jumpToHour = recMatch.endingHour.hour;
              }
            } else {
              recMatch = null;
            }
            if (recMatch != null) {
              if (concurrentMatches.any((match) =>
                  match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                match = AppMatch.copyWith(concurrentMatches.firstWhere(
                    (match) =>
                        match.idRecurrentMatch == recMatch!.idRecurrentMatch));
              }
            }
          }
          if (match != null || recMatch != null) {
            dayMatches.add(
              DayMatch(
                startingHour: hour,
                recurrentMatch: recMatch,
                match: match,
              ),
            );
          } else {
            if (hour.hour >= jumpToHour) {
              dayMatches.add(
                DayMatch(
                  startingHour: hour,
                ),
              );
            }
          }
        }
        selectedDayMatches.add(
          CalendarDailyCourtMatch(
            court: court,
            dayMatches: dayMatches
                .map((dayMatch) => DayMatch.copyWith(dayMatch))
                .toList(),
          ),
        );
      }
    } else {
      for (var court in courts) {
        dayMatches.clear();
        jumpToHour = -1;
        if (court.operationDays
            .firstWhere((element) => element.weekday == selectedWeekday)
            .allowReccurrent) {
          List<AppRecurrentMatch> filteredRecurrentMatches = recurrentMatches
              .where((recMatch) =>
                  recMatch.court.idStoreCourt == court.idStoreCourt &&
                  recMatch.weekday == selectedWeekday)
              .toList();
          for (var hour in selectedDayWorkingHours) {
            AppRecurrentMatch? recMatch;
            if (filteredRecurrentMatches
                .any((element) => element.startingHour == hour)) {
              recMatch = filteredRecurrentMatches
                  .firstWhere((element) => element.startingHour == hour);
              dayMatches.add(
                DayMatch(
                  startingHour: hour,
                  recurrentMatch: AppRecurrentMatch.copyWith(recMatch),
                ),
              );
              jumpToHour = recMatch.endingHour.hour;
            } else if (hour.hour >= jumpToHour) {
              dayMatches.add(
                DayMatch(
                  startingHour: hour,
                ),
              );
            }
          }
        }
        selectedDayMatches.add(
          CalendarDailyCourtMatch(
            court: court,
            dayMatches: dayMatches
                .map((dayMatch) => DayMatch.copyWith(dayMatch))
                .toList(),
          ),
        );
      }
    }

    return selectedDayMatches;
  }

  List<Hour> get minMaxHourRangeWeek {
    List<StoreWorkingDay> availableStoreWorkingDays = [];
    for (var storeDay in storeWorkingDays) {
      if (storeDay.isEnabled) {
        availableStoreWorkingDays.add(StoreWorkingDay.copyFrom(storeDay));
      }
    }

    Hour minHour = availableStoreWorkingDays
        .reduce((a, b) => a.startingHour!.hour <= b.startingHour!.hour ? a : b)
        .startingHour!;
    Hour maxHour = availableStoreWorkingDays
        .reduce((a, b) => a.endingHour!.hour >= b.endingHour!.hour ? a : b)
        .endingHour!;
    return availableHours
        .where((hour) => hour.hour >= minHour.hour && hour.hour < maxHour.hour)
        .toList();
  }

  List<CalendarWeeklyDayMatch> get selectedWeekMatches {
    List<CalendarWeeklyDayMatch> selectedWeekMatches = [];
    List<DayMatch> dayMatches = [];

    if (calendarType == CalendarType.Match) {
      for (var day in selectedWeek) {
        dayMatches.clear();

        for (var hour in minMaxHourRangeWeek) {
          List<AppMatch> filteredMatches = [];
          List<AppRecurrentMatch> filteredRecurrentMatches = [];

          for (var match in matches) {
            if (areInTheSameDay(match.date, day) &&
                hour.hour >= match.startingHour.hour &&
                hour.hour < match.endingHour.hour) {
              filteredMatches.add(AppMatch.copyWith(match));
            }
          }
          for (var recurrentMatch in recurrentMatches) {
            if (getSFWeekday(day.weekday) == recurrentMatch.weekday &&
                hour.hour >= recurrentMatch.startingHour.hour &&
                hour.hour < recurrentMatch.endingHour.hour) {
              filteredRecurrentMatches
                  .add(AppRecurrentMatch.copyWith(recurrentMatch));
            }
          }

          dayMatches.add(
            DayMatch(
              startingHour: hour,
              matches: filteredMatches,
              recurrentMatches: filteredRecurrentMatches,
              operationHour: storeWorkingDays
                      .firstWhere((workingDay) =>
                          workingDay.weekday == getSFWeekday(day.weekday))
                      .isEnabled &&
                  storeWorkingDays
                          .firstWhere((workingDay) =>
                              workingDay.weekday == getSFWeekday(day.weekday))
                          .startingHour!
                          .hour <=
                      hour.hour &&
                  storeWorkingDays
                          .firstWhere((workingDay) =>
                              workingDay.weekday == getSFWeekday(day.weekday))
                          .endingHour!
                          .hour >
                      hour.hour,
            ),
          );
        }
        selectedWeekMatches.add(
          CalendarWeeklyDayMatch(
            date: day,
            dayMatches: dayMatches
                .map((dayMatch) => DayMatch.copyWith(dayMatch))
                .toList(),
          ),
        );
      }
    } else {
      for (var day in selectedWeek) {
        dayMatches.clear();

        for (var hour in minMaxHourRangeWeek) {
          List<AppRecurrentMatch> filteredRecurrentMatches = [];

          for (var recurrentMatch in recurrentMatches) {
            if (recurrentMatch.weekday == getSFWeekday(day.weekday) &&
                hour.hour >= recurrentMatch.startingHour.hour &&
                hour.hour < recurrentMatch.endingHour.hour) {
              filteredRecurrentMatches
                  .add(AppRecurrentMatch.copyWith(recurrentMatch));
            }
          }

          dayMatches.add(
            DayMatch(
              startingHour: hour,
              recurrentMatches: filteredRecurrentMatches,
              operationHour: storeWorkingDays
                      .firstWhere((workingDay) =>
                          workingDay.weekday == getSFWeekday(day.weekday))
                      .isEnabled &&
                  storeWorkingDays
                          .firstWhere((workingDay) =>
                              workingDay.weekday == getSFWeekday(day.weekday))
                          .startingHour!
                          .hour <=
                      hour.hour &&
                  storeWorkingDays
                          .firstWhere((workingDay) =>
                              workingDay.weekday == getSFWeekday(day.weekday))
                          .endingHour!
                          .hour >
                      hour.hour,
            ),
          );
        }
        selectedWeekMatches.add(
          CalendarWeeklyDayMatch(
            date: day,
            dayMatches: dayMatches
                .map((dayMatch) => DayMatch.copyWith(dayMatch))
                .toList(),
          ),
        );
      }
    }

    return selectedWeekMatches;
  }

  bool _showHourInfoMobile = false;
  bool get showHourInfoMobile => _showHourInfoMobile;
  void setShowHourInfo({bool? value}) {
    if (value != null) {
      _showHourInfoMobile = value;
    } else {
      _showHourInfoMobile = !_showHourInfoMobile;
    }
    // if (!_showHourInfoMobile && hourInformation != null) {
    //   hourInformation!.selectedRow = 0;
    //   hourInformation!.selectedColumn = 0;
    // }
    notifyListeners();
  }

  HourInformation? hourInformation;

  bool _isHourInformationExpanded = false;
  bool get isHourInformationExpanded => _isHourInformationExpanded;
  void setIsHourInformationExpanded({bool? value}) {
    if (value != null) {
      _isHourInformationExpanded = value;
    } else {
      _isHourInformationExpanded = !_isHourInformationExpanded;
    }
    notifyListeners();
  }

  void onTapHour(HourInformation newHourInformation) {
    setIsHourInformationExpanded(value: false);

    hourInformation = newHourInformation;
    notifyListeners();
    if (!showHourInfoMobile) {
      setShowHourInfo();
    }
  }

  void onTapCancelOptions(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      CancelOptionsModal(
        onReturn: () => returnMainView(context),
        selectedDay: selectedDay,
        recurrentMatch: hourInformation!.refRecurrentMatch!,
        onCancel: (calendarType) {
          if (calendarType == CalendarType.Match) {
            if (hourInformation!.refRecurrentMatch!.blocked) {
              unblockHour(
                  context,
                  hourInformation!.refRecurrentMatch!.court.idStoreCourt!,
                  selectedDay,
                  hourInformation!.refRecurrentMatch!.startingHour);
            } else {
              if (hourInformation!.refMatch != null) {
                cancelMatch(context, hourInformation!.refMatch!.idMatch);
              }
            }
          } else {
            if (hourInformation!.refRecurrentMatch!.blocked) {
              recurrentUnblockHour(context,
                  hourInformation!.refRecurrentMatch!.idRecurrentMatch);
            } else {
              cancelRecurrentMatch(context,
                  hourInformation!.refRecurrentMatch!.idRecurrentMatch);
            }
          }
        },
      ),
    );
  }

  void onTapCancelMatchHourInformation(BuildContext context) {
    if (hourInformation!.match) {
      if (hourInformation!.refMatch!.blocked) {
        unblockHour(
          context,
          hourInformation!.refMatch!.court.idStoreCourt!,
          hourInformation!.refMatch!.date,
          hourInformation!.refMatch!.startingHour,
        );
      } else {
        setMatchCancelWidget(context, hourInformation!.refMatch!);
      }
    }
  }

  void blockHour(
    BuildContext context,
    int idStoreCourt,
    DateTime date,
    Hour hour,
    Player player,
    int idSport,
    String obs,
    double price,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .blockHour(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idStoreCourt,
      date,
      hour.hour,
      player,
      idSport,
      obs,
      price,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setMatchesFromResponse(context, response.responseBody!);

        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
      setShowHourInfo(value: false);
    });
  }

  void unblockHour(
    BuildContext context,
    int idStoreCourt,
    DateTime date,
    Hour hour,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .unblockHour(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idStoreCourt,
      date,
      hour.hour,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setMatchesFromResponse(context, response.responseBody!);

        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
      setShowHourInfo(value: false);
    });
  }

  void recurrentBlockHour(
    BuildContext context,
    int idStoreCourt,
    Hour hour,
    Player player,
    int idSport,
    String obs,
    double price,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .recurrentBlockHour(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idStoreCourt,
      selectedWeekday,
      hour.hour,
      player,
      idSport,
      obs,
      price,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setRecurrentMatchesFromResponse(context, response.responseBody!);
        Provider.of<MenuProvider>(context, listen: false).closeModal();
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void recurrentUnblockHour(BuildContext context, int idRecurrentMatch) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .recurrentUnblockHour(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idRecurrentMatch,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setRecurrentMatchesFromResponse(context, response.responseBody!);
        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void cancelMatch(
    BuildContext context,
    int idMatch,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .cancelMatch(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idMatch,
      cancelMatchReasonController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setMatchesFromResponse(context, response.responseBody!);
        cancelMatchReasonController.text = "";
        setShowHourInfo(value: false);
        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void cancelRecurrentMatch(
    BuildContext context,
    int idRecurrentMatch,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    calendarRepo
        .cancelRecurrentMatch(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      idRecurrentMatch,
      cancelRecurrentMatchReasonController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setRecurrentMatchesFromResponse(context, response.responseBody!);

        cancelRecurrentMatchReasonController.text = "";
        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void setMatchesFromResponse(
    BuildContext context,
    String response,
  ) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    if (matchesStartDate ==
        Provider.of<DataProvider>(context, listen: false).matchesStartDate) {
      Provider.of<DataProvider>(context, listen: false)
          .setMatches(responseBody);
    }
    matches.clear();
    for (var match in responseBody['Matches']) {
      matches.add(
        AppMatch.fromJson(
          match,
          Provider.of<DataProvider>(context, listen: false).availableHours,
          Provider.of<DataProvider>(context, listen: false).availableSports,
        ),
      );
    }
    notifyListeners();
  }

  void setRecurrentMatchesFromResponse(
    BuildContext context,
    String response,
  ) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );

    Provider.of<DataProvider>(context, listen: false)
        .setRecurrentMatches(responseBody);

    recurrentMatches.clear();
    for (var recurrentMatch in responseBody['RecurrentMatches']) {
      recurrentMatches.add(
        AppRecurrentMatch.fromJson(
          recurrentMatch,
          Provider.of<DataProvider>(context, listen: false).availableHours,
          Provider.of<DataProvider>(context, listen: false).availableSports,
        ),
      );
    }
  }

  void setBlockHourWidget(
    BuildContext context,
    Court court,
    Hour hour,
  ) {
    int standardPrice = Provider.of<DataProvider>(context, listen: false)
        .courts
        .firstWhere(
          (loopCourt) => loopCourt.idStoreCourt == court.idStoreCourt,
        )
        .operationDays
        .firstWhere(
          (opDay) =>
              opDay.weekday ==
              getSFWeekday(
                selectedDay.weekday,
              ),
        )
        .prices
        .firstWhere(
          (hourPrice) => hourPrice.startingHour.hour == hour.hour,
        )
        .price;

    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      BlockHourWidget(
        isRecurrent: false,
        court: court,
        day: selectedDay,
        hour: hour,
        standardPrice: standardPrice.toDouble(),
        sports:
            Provider.of<DataProvider>(context, listen: false).availableSports,
        onBlock: (player, idSport, obs, price) => blockHour(
          context,
          court.idStoreCourt!,
          selectedDay,
          hour,
          player,
          idSport,
          obs,
          price,
        ),
        onAddNewPlayer: () => genericAddNewPlayer(
          context,
          () => setBlockHourWidget(
            context,
            court,
            hour,
          ),
        ),
        onReturn: () => returnMainView(context),
      ),
    );
  }

  void setRecurrentBlockHourWidget(
      BuildContext context, Court court, Hour hour) {
    HourPrice standardPrice = Provider.of<DataProvider>(context, listen: false)
        .courts
        .firstWhere(
          (loopCourt) => loopCourt.idStoreCourt == court.idStoreCourt,
        )
        .operationDays
        .firstWhere(
          (opDay) => opDay.weekday == selectedWeekday,
        )
        .prices
        .firstWhere(
          (hourPrice) => hourPrice.startingHour.hour == hour.hour,
        );
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      BlockHourWidget(
        isRecurrent: true,
        court: court,
        day: selectedDay,
        standardPrice: standardPrice.recurrentPrice?.toDouble() ??
            standardPrice.price.toDouble(),
        sports:
            Provider.of<DataProvider>(context, listen: false).availableSports,
        hour: hour,
        onBlock: (player, idSport, obs, price) => recurrentBlockHour(
          context,
          court.idStoreCourt!,
          hour,
          player,
          idSport,
          obs,
          price,
        ),
        onAddNewPlayer: () => genericAddNewPlayer(
          context,
          () => setRecurrentBlockHourWidget(
            context,
            court,
            hour,
          ),
        ),
        onReturn: () => returnMainView(context),
      ),
    );
  }

  void genericAddNewPlayer(BuildContext context, VoidCallback callbackParent) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      StorePlayerWidget(
        editPlayer: null,
        onReturn: () => callbackParent(),
        onSavePlayer: (a) {},
        onCreatePlayer: (player) {
          Provider.of<MenuProvider>(context, listen: false).setModalLoading();
          playersRepo
              .addPlayer(
            context,
            Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
            player,
          )
              .then((response) {
            if (response.responseStatus == NetworkResponseStatus.success) {
              Map<String, dynamic> responseBody = json.decode(
                response.responseBody!,
              );

              Provider.of<DataProvider>(context, listen: false)
                  .setPlayersResponse(responseBody);

              Provider.of<MenuProvider>(context, listen: false).setMessageModal(
                "Jogador(a) adicionado(a)!",
                null,
                true,
                onTap: () => callbackParent(),
              );
            } else if (response.responseStatus ==
                NetworkResponseStatus.expiredToken) {
              Provider.of<MenuProvider>(context, listen: false).logout(context);
            } else {
              Provider.of<MenuProvider>(context, listen: false)
                  .setMessageModalFromResponse(response);
            }
          });
        },
        sports:
            Provider.of<DataProvider>(context, listen: false).availableSports,
        ranks: Provider.of<DataProvider>(context, listen: false).availableRanks,
        genders:
            Provider.of<DataProvider>(context, listen: false).availableGenders,
      ),
    );
  }

  void setAddMatchWidget(
    BuildContext context,
    Court court,
    Hour timeBegin,
    Hour timeEnd, {
    CalendarType? calendarType,
  }) {
    if (!isHourPast(selectedDay, timeBegin)) {
      HourPrice standardPrice =
          Provider.of<DataProvider>(context, listen: false)
              .courts
              .firstWhere(
                (loopCourt) => loopCourt.idStoreCourt == court.idStoreCourt,
              )
              .operationDays
              .firstWhere(
                (opDay) =>
                    opDay.weekday ==
                    getSFWeekday(
                      selectedDay.weekday,
                    ),
              )
              .prices
              .firstWhere(
                (hourPrice) => hourPrice.startingHour.hour == timeBegin.hour,
              );
      Provider.of<MenuProvider>(context, listen: false).setModalForm(
        AddMatchModal(
          onReturn: () => returnMainView(context),
          onSelected: (blockMatch) {
            if (blockMatch.isRecurrent) {
              recurrentBlockHour(
                context,
                blockMatch.idStoreCourt,
                blockMatch.timeBegin,
                blockMatch.player,
                blockMatch.idSport,
                blockMatch.observation,
                blockMatch.price,
              );
            } else {
              blockHour(
                context,
                blockMatch.idStoreCourt,
                selectedDay,
                blockMatch.timeBegin,
                blockMatch.player,
                blockMatch.idSport,
                blockMatch.observation,
                blockMatch.price,
              );
            }
          },
          onAddNewPlayer: (calendarType) => genericAddNewPlayer(
            context,
            () => setAddMatchWidget(
              context,
              court,
              timeBegin,
              timeEnd,
              calendarType: calendarType,
            ),
          ),
          court: court,
          timeBegin: timeBegin,
          timeEnd: timeEnd,
          initCalendarType: calendarType,
          currentHourPrice: standardPrice,
        ),
      );
    }
  }

  void setMatchDetailsWidget(BuildContext context, AppMatch match) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      MatchDetailsWidget(
        match: match,
        onReturn: () => returnMainView(context),
        onCancel: () => setMatchCancelWidget(
          context,
          match,
        ),
      ),
    );
  }

  void setRecurrentMatchDetailsWidget(
      BuildContext context, AppRecurrentMatch recurrentMatch) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      RecurrentMatchDetailsWidget(
        recurrentMatch: recurrentMatch,
        onReturn: () => returnMainView(context),
        onCancel: () => setRecurrentMatchCancelWidget(
          context,
          recurrentMatch,
        ),
      ),
    );
  }

  void setCourtsAvailabilityWidget(
    BuildContext context,
    DateTime day,
    Hour hour,
    List<AppMatch> matches,
    List<AppRecurrentMatch> recurrentMatches,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      CourtsAvailabilityWidget(
        viewModel: this,
        day: day,
        hour: hour,
        matches: matches,
        recurrentMatches: recurrentMatches,
      ),
    );
  }

  void setRecurrentCourtsAvailabilityWidget(
    BuildContext context,
    DateTime day,
    DayMatch dayMatch,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      RecurrentCourtsAvailabilityWidget(
        viewModel: this,
        day: day,
        dayMatch: dayMatch,
      ),
    );
  }

  void setMatchCancelWidget(
    BuildContext context,
    AppMatch match,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      MatchCancelWidget(
        match: match,
        controller: cancelMatchReasonController,
        onReturn: () => returnMainView(context),
        onCancel: () => cancelMatch(context, match.idMatch),
      ),
    );
  }

  void setRecurrentMatchCancelWidget(
    BuildContext context,
    AppRecurrentMatch recurrentMatch,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      RecurrentMatchCancelWidget(
        recurrentMatch: recurrentMatch,
        controller: cancelRecurrentMatchReasonController,
        onReturn: () => returnMainView(context),
        onCancel: () =>
            cancelRecurrentMatch(context, recurrentMatch.idRecurrentMatch),
      ),
    );
  }

  void returnMainView(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  onTapColorsDescription(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      ColorsDescriptionModal(
        onReturn: () => returnMainView(context),
      ),
    );
  }
}
