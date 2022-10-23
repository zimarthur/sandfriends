import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/models/side_preference.dart';
import '../models/gender.dart';
import '../models/rank.dart';
import '../models/sport.dart';

class CategoriesProvider with ChangeNotifier {
  void clearCategories() {
    clearGenders();
    clearRanks();
    clearSidePreferences();
    clearSports();
  }

  // Sports
  List<Sport> _sports = [];
  List<Sport> get sports => _sports;
  void addSport(Sport sport) {
    bool isNewSport = true;
    for (int i = 0; i < _sports.length; i++) {
      if (_sports[i].idSport == sport.idSport) {
        isNewSport = false;
        break;
      }
    }
    if (isNewSport) {
      _sports.add(sport);
      notifyListeners();
    }
  }

  void clearSports() {
    _sports.clear();
    notifyListeners();
  }

  // Genders
  List<Gender> _genders = [];
  List<Gender> get genders => _genders;
  void addGender(Gender gender) {
    bool isNewGender = true;
    for (int i = 0; i < _genders.length; i++) {
      if (_genders[i].idGender == gender.idGender) {
        isNewGender = false;
        break;
      }
    }
    if (isNewGender) {
      _genders.add(gender);
      notifyListeners();
    }
  }

  void clearGenders() {
    _genders.clear();
    notifyListeners();
  }

  // Ranks
  List<Rank> _ranks = [];
  List<Rank> get ranks => _ranks;
  void addRank(Rank rank) {
    bool isNewRank = true;
    for (int i = 0; i < _ranks.length; i++) {
      if (_ranks[i].idRankCategory == rank.idRankCategory) {
        isNewRank = false;
        break;
      }
    }
    if (isNewRank) {
      _ranks.add(rank);
      notifyListeners();
    }
  }

  void clearRanks() {
    _ranks.clear();
    notifyListeners();
  }

  // Side Preferences
  List<SidePreference> _sidePreferences = [];
  List<SidePreference> get sidePreferences => _sidePreferences;
  void addSidePreference(SidePreference sidePreference) {
    bool isNewSidePreference = true;
    for (int i = 0; i < _sidePreferences.length; i++) {
      if (_sidePreferences[i].idSidePreference ==
          sidePreference.idSidePreference) {
        isNewSidePreference = false;
        break;
      }
    }
    if (isNewSidePreference) {
      _sidePreferences.add(sidePreference);
      notifyListeners();
    }
  }

  void clearSidePreferences() {
    _sidePreferences.clear();
    notifyListeners();
  }

  bool cointainsEmpyList() {
    return (sports.isEmpty ||
        genders.isEmpty ||
        ranks.isEmpty ||
        sidePreferences.isEmpty);
  }

  //MONTHS
  List monthsPortuguese = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];
}
