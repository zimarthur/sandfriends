import 'package:flutter/material.dart';
import 'package:sandfriends/models/court.dart';

import '../models/enums.dart';

class MatchProvider with ChangeNotifier {
  Sport? _matchSport;
  Sport? get matchSport => _matchSport;
  set matchSport(Sport? value) {
    _matchSport = value;
  }

  EnumSearchStatus _searchStatus = EnumSearchStatus.NoFilterApplied;
  EnumSearchStatus get searchStatus => _searchStatus;
  set searchStatus(EnumSearchStatus value) {
    _searchStatus = value;
    notifyListeners();
  }

  int? _selectedCourt;
  int? get selectedCourt => _selectedCourt;
  set selectedCourt(int? value) {
    _selectedCourt = value;
    notifyListeners();
  }

  int? _selectedTime;
  int? get selectedTime => _selectedTime;
  set selectedTime(int? value) {
    _selectedTime = value;
    notifyListeners();
  }

  List<Court> _courts = [];

  List<Court> get courts => _courts;

  void addCourt(Court court) {
    _courts.add(court);
    notifyListeners();
  }

  void clearCourts() {
    _courts.clear();
    notifyListeners();
  }
}
