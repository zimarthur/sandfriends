import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/SFModalMessage.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/HourPrice/HourPriceStore.dart';
import '../../../../Common/Model/SandfriendsQuadras/StoreWorkingHours.dart';
import '../../../../Common/Model/TabItem.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/SFDateTime.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/StoreProvider.dart';
import '../../Menu/ViewModel/MenuProviderQuadras.dart';
import 'package:intl/intl.dart';

import '../../Players/Repository/PlayersRepo.dart';
import '../../Players/View/Web/StorePlayerWidget.dart';
import '../Model/CalendarDailyCourtMatch.dart';
import '../Model/CalendarType.dart';
import '../Model/CalendarWeeklyDayMatch.dart';
import '../Model/DayMatch.dart';
import '../Model/HourInformation.dart';
import '../Model/PeriodType.dart';
import '../Repository/CalendarRepo.dart';
import '../View/Mobile/AddMatchModal/AddMatchModal.dart';
import '../View/Mobile/ColorsDescriptionModa.dart';
import '../View/Web/Modal/BlockHourWidget.dart';
import '../View/Web/Modal/CancelOptionsModal.dart';
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
  List<AppMatchStore> matches = [];
  List<AppRecurrentMatchStore> recurrentMatches = [];
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
    Provider.of<MenuProviderQuadras>(context, listen: false).isDrawerExpanded =
        false;
    courts = Provider.of<StoreProvider>(context, listen: false).courts;
    storeWorkingDays =
        Provider.of<StoreProvider>(context, listen: false).storeWorkingDays !=
                null
            ? Provider.of<StoreProvider>(context, listen: false)
                .storeWorkingDays!
                .map((workingDay) => StoreWorkingDay.copyFrom(workingDay))
                .toList()
            : [];

    availableHours =
        Provider.of<CategoriesProvider>(context, listen: false).hours;
    matches = Provider.of<StoreProvider>(context, listen: false)
        .allMatches
        .map((match) => AppMatchStore.copyWith(match))
        .toList();

    recurrentMatches = Provider.of<StoreProvider>(context, listen: false)
        .recurrentMatches
        .map((recMatch) => AppRecurrentMatchStore.copyWith(recMatch))
        .toList();
    matchesStartDate =
        Provider.of<StoreProvider>(context, listen: false).matchesStartDate;
    matchesEndDate =
        Provider.of<StoreProvider>(context, listen: false).matchesEndDate;
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
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      calendarRepo
          .updateMatchesList(
              context,
              Provider.of<StoreProvider>(context, listen: false)
                  .loggedAccessToken,
              newSelectedDay)
          .then((response) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          matches.clear();
          for (var match in responseBody['Matches']) {
            matches.add(
              AppMatchStore.fromJson(
                match,
                Provider.of<CategoriesProvider>(context, listen: false).hours,
                Provider.of<CategoriesProvider>(context, listen: false).sports,
              ),
            );
          }
          matchesStartDate =
              DateFormat("dd/MM/yyyy").parse(responseBody['MatchesStartDate']);
          matchesEndDate =
              DateFormat("dd/MM/yyyy").parse(responseBody['MatchesEndDate']);
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          _selectedDay = newSelectedDay;
          notifyListeners();
        } else if (response.responseStatus ==
            NetworkResponseStatus.expiredToken) {
          Provider.of<MenuProviderQuadras>(context, listen: false)
              .logout(context);
        } else {
          Provider.of<MenuProviderQuadras>(context, listen: false)
              .setMessageModalFromResponse(context, response);
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
      List<AppMatchStore> filteredMatches = matches
          .where((match) =>
              match.court.idStoreCourt == court.idStoreCourt &&
              areInTheSameDay(match.date, selectedDay))
          .toList();
      for (var hour in selectedDayWorkingHours) {
        AppMatchStore? match;
        AppRecurrentMatchStore? recMatch;
        List<AppMatchStore> concurrentMatches = [];
        bool hasMatch = filteredMatches.any((element) =>
            element.timeBegin == hour ||
            (element.timeBegin.hour < hour.hour &&
                element.timeEnd.hour > hour.hour));
        if (hasMatch) {
          concurrentMatches = filteredMatches
              .where((element) =>
                  element.timeBegin == hour ||
                  (element.timeBegin.hour < hour.hour &&
                      element.timeEnd.hour > hour.hour))
              .toList();
        }

        DayMatch dayMatch = DayMatch(startingHour: hour);

        if (concurrentMatches.any((match) =>
            !match.isFromRecurrentMatch && match.canceled == false)) {
          dayMatch.match = AppMatchStore.copyWith(concurrentMatches.firstWhere(
              (match) =>
                  !match.isFromRecurrentMatch && match.canceled == false));
        } else if (recurrentMatches.any((recMatch) =>
            recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
            recMatch.timeBegin == hour &&
            recMatch.court.idStoreCourt == court.idStoreCourt)) {
          {
            recMatch = recurrentMatches.firstWhere((recMatch) =>
                recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
                recMatch.timeBegin == hour &&
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
                        AppRecurrentMatchStore.copyWith(recMatch);
                  }
                } else {
                  dayMatch.recurrentMatch =
                      AppRecurrentMatchStore.copyWith(recMatch);
                }
              } else {
                dayMatch.recurrentMatch =
                    AppRecurrentMatchStore.copyWith(recMatch);
              }
            } else {
              dayMatch.recurrentMatch = null;
            }
            if (dayMatch.recurrentMatch != null) {
              if (concurrentMatches.any((match) =>
                  match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                dayMatch.match = AppMatchStore.copyWith(
                    concurrentMatches.firstWhere((match) =>
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
        List<AppMatchStore> filteredMatches = matches
            .where((match) =>
                match.court.idStoreCourt == court.idStoreCourt &&
                areInTheSameDay(match.date, selectedDay))
            .toList();
        for (var hour in selectedDayWorkingHours) {
          AppMatchStore? match;
          AppRecurrentMatchStore? recMatch;
          List<AppMatchStore> concurrentMatches = [];
          bool hasMatch =
              filteredMatches.any((element) => element.timeBegin == hour);
          if (hasMatch) {
            concurrentMatches = filteredMatches
                .where((element) => element.timeBegin == hour)
                .toList();
          }
          if (concurrentMatches.any((match) =>
              !match.isFromRecurrentMatch && match.canceled == false)) {
            match = AppMatchStore.copyWith(concurrentMatches.firstWhere(
                (match) =>
                    !match.isFromRecurrentMatch && match.canceled == false));
            jumpToHour = match.timeEnd.hour;
          } else if (recurrentMatches.any((recMatch) =>
              recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
              recMatch.timeBegin == hour &&
              recMatch.court.idStoreCourt == court.idStoreCourt)) {
            recMatch = recurrentMatches.firstWhere((recMatch) =>
                recMatch.weekday == getSFWeekday(selectedDay.weekday) &&
                recMatch.timeBegin == hour &&
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
                    recMatch = AppRecurrentMatchStore.copyWith(recMatch);
                    jumpToHour = recMatch.timeEnd.hour;
                  }
                }
              } else {
                recMatch = AppRecurrentMatchStore.copyWith(recMatch);
                jumpToHour = recMatch.timeEnd.hour;
              }
            } else {
              recMatch = null;
            }
            if (recMatch != null) {
              if (concurrentMatches.any((match) =>
                  match.idRecurrentMatch == recMatch!.idRecurrentMatch)) {
                match = AppMatchStore.copyWith(concurrentMatches.firstWhere(
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
          List<AppRecurrentMatchStore> filteredRecurrentMatches =
              recurrentMatches
                  .where((recMatch) =>
                      recMatch.court.idStoreCourt == court.idStoreCourt &&
                      recMatch.weekday == selectedWeekday)
                  .toList();
          for (var hour in selectedDayWorkingHours) {
            AppRecurrentMatchStore? recMatch;
            if (filteredRecurrentMatches
                .any((element) => element.timeBegin == hour)) {
              recMatch = filteredRecurrentMatches
                  .firstWhere((element) => element.timeBegin == hour);
              dayMatches.add(
                DayMatch(
                  startingHour: hour,
                  recurrentMatch: AppRecurrentMatchStore.copyWith(recMatch),
                ),
              );
              jumpToHour = recMatch.timeEnd.hour;
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
          List<AppMatchStore> filteredMatches = [];
          List<AppRecurrentMatchStore> filteredRecurrentMatches = [];

          for (var match in matches) {
            if (areInTheSameDay(match.date, day) &&
                hour.hour >= match.timeBegin.hour &&
                hour.hour < match.timeEnd.hour) {
              filteredMatches.add(AppMatchStore.copyWith(match));
            }
          }
          for (var recurrentMatch in recurrentMatches) {
            if (getSFWeekday(day.weekday) == recurrentMatch.weekday &&
                hour.hour >= recurrentMatch.timeBegin.hour &&
                hour.hour < recurrentMatch.timeEnd.hour) {
              filteredRecurrentMatches
                  .add(AppRecurrentMatchStore.copyWith(recurrentMatch));
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
          List<AppRecurrentMatchStore> filteredRecurrentMatches = [];

          for (var recurrentMatch in recurrentMatches) {
            if (recurrentMatch.weekday == getSFWeekday(day.weekday) &&
                hour.hour >= recurrentMatch.timeBegin.hour &&
                hour.hour < recurrentMatch.timeEnd.hour) {
              filteredRecurrentMatches
                  .add(AppRecurrentMatchStore.copyWith(recurrentMatch));
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
                  hourInformation!.refRecurrentMatch!.timeBegin);
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
          hourInformation!.refMatch!.timeBegin,
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
    UserStore player,
    int idSport,
    String obs,
    double price,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .blockHour(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
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

        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .unblockHour(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      idStoreCourt,
      date,
      hour.hour,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setMatchesFromResponse(context, response.responseBody!);

        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
      }
      setShowHourInfo(value: false);
    });
  }

  void recurrentBlockHour(
    BuildContext context,
    int idStoreCourt,
    Hour hour,
    UserStore player,
    int idSport,
    String obs,
    double price,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .recurrentBlockHour(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
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
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
      }
    });
  }

  void recurrentUnblockHour(BuildContext context, int idRecurrentMatch) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .recurrentUnblockHour(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      idRecurrentMatch,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setRecurrentMatchesFromResponse(context, response.responseBody!);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
      }
    });
  }

  void cancelMatch(
    BuildContext context,
    int idMatch,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .cancelMatch(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      idMatch,
      cancelMatchReasonController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setMatchesFromResponse(context, response.responseBody!);
        cancelMatchReasonController.text = "";
        setShowHourInfo(value: false);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
      }
    });
  }

  void cancelRecurrentMatch(
    BuildContext context,
    int idRecurrentMatch,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    calendarRepo
        .cancelRecurrentMatch(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      idRecurrentMatch,
      cancelRecurrentMatchReasonController.text,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        setShowHourInfo(value: false);
        setRecurrentMatchesFromResponse(context, response.responseBody!);

        cancelRecurrentMatchReasonController.text = "";
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
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
        Provider.of<StoreProvider>(context, listen: false).matchesStartDate) {
      Provider.of<StoreProvider>(context, listen: false)
          .setMatches(context, responseBody);
    }
    matches.clear();
    for (var match in responseBody['Matches']) {
      matches.add(
        AppMatchStore.fromJson(
          match,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
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

    Provider.of<StoreProvider>(context, listen: false)
        .setRecurrentMatches(context, responseBody);

    recurrentMatches.clear();
    for (var recurrentMatch in responseBody['RecurrentMatches']) {
      recurrentMatches.add(
        AppRecurrentMatchStore.fromJson(
          recurrentMatch,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        ),
      );
    }
  }

  void setBlockHourWidget(
    BuildContext context,
    Court court,
    Hour hour,
  ) {
    int standardPrice = Provider.of<StoreProvider>(context, listen: false)
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

    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      BlockHourWidget(
        isRecurrent: false,
        court: court,
        day: selectedDay,
        hour: hour,
        standardPrice: standardPrice.toDouble(),
        sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
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
    HourPriceStore standardPrice =
        Provider.of<StoreProvider>(context, listen: false)
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      BlockHourWidget(
        isRecurrent: true,
        court: court,
        day: selectedDay,
        standardPrice: standardPrice.recurrentPrice?.toDouble() ??
            standardPrice.price.toDouble(),
        sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      StorePlayerWidget(
        editPlayer: null,
        onReturn: () => callbackParent(),
        onSavePlayer: (a) {},
        onCreatePlayer: (player) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setLoading();
          playersRepo
              .addPlayer(
            context,
            Provider.of<StoreProvider>(context, listen: false)
                .loggedAccessToken,
            player,
          )
              .then((response) {
            if (response.responseStatus == NetworkResponseStatus.success) {
              Map<String, dynamic> responseBody = json.decode(
                response.responseBody!,
              );

              Provider.of<StoreProvider>(context, listen: false)
                  .setPlayersResponse(context, responseBody);

              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addModalMessage(
                SFModalMessage(
                  title: "Jogador(a) adicionado(a)!",
                  onTap: () {
                    callbackParent();
                  },
                  isHappy: true,
                ),
              );
            } else if (response.responseStatus ==
                NetworkResponseStatus.expiredToken) {
              Provider.of<MenuProviderQuadras>(context, listen: false)
                  .logout(context);
            } else {
              Provider.of<MenuProviderQuadras>(context, listen: false)
                  .setMessageModalFromResponse(context, response);
            }
          });
        },
        sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
        ranks: Provider.of<CategoriesProvider>(context, listen: false).ranks,
        genders:
            Provider.of<CategoriesProvider>(context, listen: false).genders,
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
      HourPriceStore standardPrice =
          Provider.of<StoreProvider>(context, listen: false)
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
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addOverlayWidget(
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

  void setMatchDetailsWidget(BuildContext context, AppMatchStore match) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
      BuildContext context, AppRecurrentMatchStore recurrentMatch) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
    List<AppMatchStore> matches,
    List<AppRecurrentMatchStore> recurrentMatches,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      RecurrentCourtsAvailabilityWidget(
        viewModel: this,
        day: day,
        dayMatch: dayMatch,
      ),
    );
  }

  void setMatchCancelWidget(
    BuildContext context,
    AppMatchStore match,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
    AppRecurrentMatchStore recurrentMatch,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
    Provider.of<StandardScreenViewModel>(context, listen: false).closeModal();
  }

  onTapColorsDescription(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ColorsDescriptionModal(
        onReturn: () => returnMainView(context),
      ),
    );
  }
}
