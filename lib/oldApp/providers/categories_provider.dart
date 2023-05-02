import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/SidePreference.dart';
import '../../SharedComponents/Model/Gender.dart';
import '../../SharedComponents/Model/Rank.dart';
import '../../SharedComponents/Model/Sport.dart';

class CategoriesProvider with ChangeNotifier {
  void clearCategories() {
    clearGenders();
    clearRanks();
    clearSidePreferences();
    clearSports();
  }

  // Sports
  final List<Sport> _sports = [];
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
  final List<Gender> _genders = [];
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
  final List<Rank> _ranks = [];
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
  final List<SidePreference> _sidePreferences = [];
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

  List monthsPortugueseComplete = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  List weekDaysPortuguese = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  List shortWeekDaysPortuguese = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];
}
