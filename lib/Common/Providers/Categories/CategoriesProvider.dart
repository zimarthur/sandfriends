import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Infrastructure.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../Sandfriends/Features/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';
import '../../../Sandfriends/Features/Home/Repository/HomeRepo.dart';
import '../../../Sandfriends/Features/Onboarding/View/OnboardingModal.dart';
import '../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../Managers/LocalStorage/LocalStorageManager.dart';
import '../../Model/Gender.dart';
import '../../Model/Hour.dart';
import '../../Model/Rank.dart';
import '../../Model/Region.dart';
import '../../Model/SidePreference.dart';
import '../../Model/Sport.dart';
import '../../Model/User/UserComplete.dart';
import '../../StandardScreen/StandardScreenViewModel.dart';
import 'Repository/CategoriesProviderRepo.dart';

class CategoriesProvider extends ChangeNotifier {
  final categoriesProviderRepo = CategoriesProviderRepo();

  List<Hour> hours = [];
  List<Sport> sports = [];
  List<Gender> genders = [];
  List<Rank> ranks = [];
  List<SidePreference> sidePreferences = [];
  List<Infrastructure> infrastructures = [];

  List<Region> regions = [];
  List<Region> availableRegions = [];

  bool get isInitialized =>
      hours.isNotEmpty &&
      sports.isNotEmpty &&
      genders.isNotEmpty &&
      ranks.isNotEmpty &&
      sidePreferences.isNotEmpty;

  Sport? sessionSport;
  void setSessionSport({Sport? sport}) {
    sessionSport = sport ?? sports.first;
    notifyListeners();
  }

  void clearAll() {
    hours.clear();
    sports.clear();
    genders.clear();
    ranks.clear();
    sidePreferences.clear();
    regions.clear();
    infrastructures.clear();
    notifyListeners();
  }

  void setCategoriesProvider(Map<String, dynamic> response) {
    clearAll();
    setHours(response);
    setSports(response);
    setGenders(response);
    setRanks(response);
    setSidePreferences(response);
    setAvailableRegions(response);
    setInfrastructures(response);
  }

  void setHours(Map<String, dynamic> response) {
    final responseHours = response['Hours'];

    for (var hour in responseHours) {
      hours.add(
        Hour.fromJson(
          hour,
        ),
      );
    }
  }

  void setSports(Map<String, dynamic> response) {
    final responseSports = response['Sports'];

    for (var sport in responseSports) {
      sports.add(
        Sport.fromJson(
          sport,
        ),
      );
    }
  }

  void setGenders(Map<String, dynamic> response) {
    final responseGenders = response['Genders'];

    for (var gender in responseGenders) {
      genders.add(
        Gender.fromJson(
          gender,
        ),
      );
    }
  }

  void setRanks(Map<String, dynamic> response) {
    final responseRanks = response['Ranks'];

    for (var rank in responseRanks) {
      ranks.add(
        Rank.fromJson(
          rank,
        ),
      );
    }
  }

  void setSidePreferences(Map<String, dynamic> response) {
    final responseSidePreferences = response['SidePreferences'];

    for (var sidePreference in responseSidePreferences) {
      sidePreferences.add(
        SidePreference.fromJson(
          sidePreference,
        ),
      );
    }
  }

  void setInfrastructures(Map<String, dynamic> response) {
    final responseInfrastructures = response['Infrastructures'];
    infrastructures.clear();
    for (var infrastructure in responseInfrastructures) {
      infrastructures.add(
        Infrastructure.fromJson(
          infrastructure,
        ),
      );
    }
  }

  void setRegions(Map<String, dynamic> response) {
    final responseAvailableLocations = response['States'];
    regions.clear();
    for (var state in responseAvailableLocations) {
      regions.add(
        Region.fromJson(
          state,
        ),
      );
    }
  }

  void setAvailableRegions(Map<String, dynamic> response) {
    if (response['States'] != null) {
      availableRegions.clear();
      for (var state in response['States']) {
        availableRegions.add(
          Region.fromJson(
            state,
          ),
        );
      }
    }
  }

  Hour getHourEnd(Hour startHour) {
    return hours.firstWhere((hour) => hour.hour - startHour.hour == 1);
  }

  Hour get getFirstHour => hours
      .reduce((hour, element) => hour.hour < element.hour ? hour : element);
  Hour get getLastHour => hours
      .reduce((hour, element) => hour.hour > element.hour ? hour : element);
  Hour get getFirstSearchHour => hours.firstWhere((hour) => hour.hour == 6);
  Hour get getLastSearchHour => hours.firstWhere((hour) => hour.hour == 23);
}
