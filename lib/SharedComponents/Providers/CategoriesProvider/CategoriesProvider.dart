import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Model/Gender.dart';
import '../../Model/Rank.dart';
import '../../Model/Region.dart';
import '../../Model/SidePreference.dart';
import '../../Model/Sport.dart';
import 'Repository/CategoriesProviderRepoImp.dart';

class CategoriesProvider extends ChangeNotifier {
  final categoriesProviderRepo = CategoriesProviderRepoImp();

  List<Sport> sports = [];
  List<Gender> genders = [];
  List<Rank> ranks = [];
  List<SidePreference> sidePreferences = [];

  List<Region> regions = [];
  List<Region> availableRegions = [];

  void clearAll() {
    sports.clear();
    genders.clear();
    ranks.clear();
    sidePreferences.clear();
    regions.clear();
    notifyListeners();
  }

  void setRegions(String response) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    for (var state in responseBody['States']) {
      regions.add(
        Region.fromJson(
          state,
        ),
      );
    }
  }

  void setAvailableRegions(String response) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    for (var state in responseBody['States']) {
      availableRegions.add(
        Region.fromJson(
          state,
        ),
      );
    }
  }
}
