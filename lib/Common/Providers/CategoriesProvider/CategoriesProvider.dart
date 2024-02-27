import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Model/Gender.dart';
import '../../Model/Hour.dart';
import '../../Model/Rank.dart';
import '../../Model/Region.dart';
import '../../Model/SidePreference.dart';
import '../../Model/Sport.dart';
import 'Repository/CategoriesProviderRepo.dart';

class CategoriesProvider extends ChangeNotifier {
  final categoriesProviderRepo = CategoriesProviderRepo();

  List<Hour> hours = [];
  List<Sport> sports = [];
  List<Gender> genders = [];
  List<Rank> ranks = [];
  List<SidePreference> sidePreferences = [];

  List<Region> regions = [];
  List<Region> availableRegions = [];

  Sport? sessionSport;
  void setSessionSport({Sport? sport}) {
    sessionSport = sport ?? sports.first;
    notifyListeners();
  }

  void clearAll() {
    sports.clear();
    genders.clear();
    ranks.clear();
    sidePreferences.clear();
    regions.clear();
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

  void setRegions(Map<String, dynamic> response) {
    final responseAvailableLocations = response['States'];

    for (var state in responseAvailableLocations) {
      regions.add(
        Region.fromJson(
          state,
        ),
      );
    }
  }

  void setAvailableRegions(Map<String, dynamic> response) {
    availableRegions.clear();
    for (var state in response['States']) {
      availableRegions.add(
        Region.fromJson(
          state,
        ),
      );
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
