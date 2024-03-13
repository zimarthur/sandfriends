import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/TimeModal.dart';
import 'package:sandfriends/Common/Features/Court/View/PhotoViewModal.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/CourtReservationModal.dart';
import 'package:sandfriends/Common/Model/OperationDayUser.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Features/Court/Model/CourtAvailableHours.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:time_range/time_range.dart';
import 'package:tuple/tuple.dart';
import '../../../../Sandfriends/Features/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';
import '../../../../Sandfriends/Features/Home/Repository/HomeRepo.dart';
import '../../../../Sandfriends/Features/Onboarding/View/OnboardingModal.dart';
import '../../../Managers/LocalStorage/LocalStorageManager.dart';
import '../../../Model/AppMatch/AppMatchUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Model/AvailableDay.dart';
import '../../../Model/Court.dart';
import '../../../Model/Hour.dart';
import '../../../Model/Sport.dart';
import '../../../Model/User/UserComplete.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/Modal/SFModalMessage.dart';
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
  final loadLoginRepo = LoadLoginRepo();
  final homeRepo = HomeRepo();

  bool isLoading = false;

  int selectedPhotoIndex = 0;
  StoreUser? store;
  List<CourtAvailableHours> _courtAvailableHours = [];
  List<CourtAvailableHours> get courtAvailableHours {
    List<CourtAvailableHours> sortedCourts = _courtAvailableHours;
    try {
      sortedCourts.sort(
        (a, b) => a.court.idStoreCourt!.compareTo(b.court.idStoreCourt!),
      );
    } catch (e) {}
    return sortedCourts;
  }

  List<HourPriceUser> selectedHourPrices = [];
  @override
  List<HourPriceUser> get hourPrices => selectedHourPrices;
  @override
  List<DateTime> get matchDates => [if (selectedDate != null) selectedDate!];

  Court? selectedCourt;
  @override
  Court get court => selectedCourt!;
  @override
  Sport get sport => selectedSport!;
  DateTime? selectedDate;
  @override
  DateTime get date => selectedDate!;
  int? selectedWeekday;
  late bool canMakeReservation;
  Hour? searchStartPeriod;
  @override
  Hour get startingHour => searchStartPeriod!;
  Hour? searchEndPeriod;
  @override
  Hour get endingHour => searchEndPeriod!;

  @override
  int? get idStore => store?.idStore;

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

  void setCourtPhotoModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      PhotoViewModal(
        imagesUrl: store!.photos,
        onClose: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .removeLastOverlay(),
      ),
    );
  }

  void setCourtReservationModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      CourtReservationModal(
        onClose: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .clearOverlays(),
      ),
      showOnlyIfLast: false,
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
    print("step 0");
    if (!Provider.of<CategoriesProvider>(context, listen: false)
        .isInitialized) {
      print("step 1");
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

      String? accessToken = await LocalStorageManager().getAccessToken(context);

      loadLoginRepo.validateLogin(context, accessToken, false).then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          print("step 2");
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          Provider.of<CategoriesProvider>(context, listen: false)
              .setCategoriesProvider(responseBody);

          final responseUser = responseBody['User'];
          //caso web, que não precisa estar logado para pesquisar quadras
          if (responseUser != null) {
            Provider.of<UserProvider>(context, listen: false)
                .setHasSearchUserData(false);
            LocalStorageManager()
                .storeAccessToken(context, responseUser['AccessToken']);

            UserComplete loggedUser = UserComplete.fromJson(
              responseUser,
            );
            Provider.of<UserProvider>(context, listen: false).user = loggedUser;

            if (loggedUser.firstName == null) {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .removeLastOverlay();
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addOverlayWidget(
                OnboardingModal(),
              );

              return;
            }
            print("step 3");
            getUserInfo(context);
          }
          print("step 4");
          Provider.of<CategoriesProvider>(context, listen: false)
              .setSessionSport(
            sport: Provider.of<UserProvider>(context, listen: false)
                .user
                ?.preferenceSport,
          );
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
          initCourtViewModel(
            context,
            newStore,
            newStoreUrl,
            newCourtAvailableHours,
            newselectedHourPrice,
            newSelectedDate,
            newSelectedWeekday,
            newSelectedSport,
            newIsRecurrent,
            newCanMakeReservation,
            newSearchStartPeriod,
            newSearchEndPeriod,
          );
        } else {}
      });
      return;
    }
    print("step 5");
    canMakeReservation = newCanMakeReservation;
    isRecurrent = newIsRecurrent ?? false;
    _courtAvailableHours.clear();
    store = newStore;

    if (store == null) {
      print("step 6");
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

      final response = await courtRepo.getStore(context, newStoreUrl);

      if (response.responseStatus == NetworkResponseStatus.success) {
        print("step 7");
        store = StoreUser.fromJson(json.decode(response.responseBody!));
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        print("step 8");
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              String homeRoute =
                  Provider.of<EnvironmentProvider>(context, listen: false)
                          .environment
                          .isSandfriendsWebApp
                      ? "/"
                      : "/home";
              if (Navigator.canPop(context)) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  homeRoute,
                  (Route<dynamic> route) => false,
                );
              } else {
                Navigator.pushNamed(context, homeRoute);
              }
            },
            isHappy: false,
          ),
        );
        return;
      }
    }
    print("step 9");
    if (newCourtAvailableHours != null) {
      print("step 10");
      selectedDate = newSelectedDate;
      selectedWeekday = newSelectedWeekday;
      selectedSport = newSelectedSport;
      _courtAvailableHours = newCourtAvailableHours;
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
      selectedCourt = _courtAvailableHours
          .firstWhere(
            (court) => court.hourPrices.any(
              (hourPrice) => hourPrice == selectedHourPrices.first,
            ),
          )
          .court;
    } else if (canMakeReservation) {
      print("step 11");
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
    print("step 13");
    if (Provider.of<UserProvider>(context, listen: false).user?.cpf != null) {
      cpfController.text =
          Provider.of<UserProvider>(context, listen: false).user!.cpf!;
    }

    notifyListeners();
    loadStoreOperationDays(context);
  }

  void getUserInfo(BuildContext context) {
    homeRepo
        .getUserInfo(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      null,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<UserProvider>(context, listen: false).clear();

        Provider.of<UserProvider>(context, listen: false)
            .receiveUserDataResponse(context, response.responseBody!);

        //canTapBackground = true;
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      }
      Provider.of<UserProvider>(context, listen: false)
          .setHasSearchUserData(true);
    });
  }

  void loadStoreOperationDays(BuildContext context) {
    print("step 14");
    courtRepo.getStoreOperationDays(context, store!.idStore).then((response) {
      print("step 15");
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
      print("step 16");
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
    print("step 12");
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

        _courtAvailableHours =
            toCourtAvailableHours(availableDays, null, selectedDate!, store!);
        isLoading = false;
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            },
            isHappy: false,
          ),
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
        _courtAvailableHours = toCourtAvailableHours(
          availableDays,
          selectedWeekday,
          null,
          store!,
        );
        isLoading = false;
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            },
            isHappy: false,
          ),
        );
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      CalendarModal(
        allowMultiDates: false,
        dateRange: [selectedDate],
        onSubmit: (newDates) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          if (newDates.length == 1) {
            selectedDate = newDates.first;
            searchStoreAvailableHours(context);
          }
        },
      ),
    );
  }

  void openTimeSelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
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
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
        },
      ),
    );
  }
}
