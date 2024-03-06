import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/Repository/RecurrentMatchDecoder.dart';
import 'package:sandfriends/Sandfriends/Features/RecurrentMatchSearch/View/WeekdayModal.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:time_range/time_range.dart';
import '../../../../Common/Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../../Common/Components/Modal/TimeModal.dart';
import '../../../../Common/Model/Store/Store.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/AvailableStore.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../Repository/RecurrentMatchSearchRepo.dart';

class RecurrentMatchSearchViewModel extends ChangeNotifier {
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
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
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
          if (response.responseStatus == NetworkResponseStatus.expiredToken) {
            //canTapBackground = false;
          }
        }
      });
    } else {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Selecione uma cidade e uma data pra buscar os horários",
          onTap: () {},
          isHappy: true,
        ),
      );
    }
  }

  void openCitySelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      CitySelectorModal(
        onlyAvailableCities: true,
        themeColor: primaryLightBlue,
        onSelectedCity: (city) {
          cityFilter = city;
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();

          notifyListeners();
        },
        userCity: Provider.of<UserProvider>(context, listen: false).user!.city,
        onReturn: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .removeLastOverlay(),
      ),
    );
  }

  void openDateSelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      WeekdayModal(
        selectedWeekdays: datesFilter,
        onSelected: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          if (timeFilter != defaultTimeFilter) {
            openTimeSelectorModal(context);
          } else {
            searchRecurrentCourts(context);
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
        onSubmit: (newTimeFilter) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          onSubmitTimeFilter(newTimeFilter);
          searchRecurrentCourts(context);
        },
        themeColor: primaryLightBlue,
      ),
    );
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
      '/quadras/${store.url}',
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
