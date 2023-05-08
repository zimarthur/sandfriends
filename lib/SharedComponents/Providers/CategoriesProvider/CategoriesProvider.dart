import 'package:flutter/material.dart';

import '../../Model/Gender.dart';
import '../../Model/Rank.dart';
import '../../Model/Region.dart';
import '../../Model/SidePreference.dart';
import '../../Model/Sport.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Sport> sports = [];
  List<Gender> genders = [];
  List<Rank> ranks = [];
  List<SidePreference> sidePreferences = [];

  List<Region> regions = [];

  void clearAll() {
    sports.clear();
    genders.clear();
    ranks.clear();
    sidePreferences.clear();
    regions.clear();
    notifyListeners();
  }
}
