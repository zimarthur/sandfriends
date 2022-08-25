import 'package:flutter/material.dart';
import 'package:sandfriends/models/court.dart';
import 'package:time_range/time_range.dart';

import '../models/city.dart';
import '../models/region.dart';
import '../models/enums.dart';
import '../models/sport.dart';

class MatchProvider with ChangeNotifier {
  List<Sport> _availableSports = [];
  List<Sport> get availableSports => _availableSports;
  void addSport(Sport sport) {
    _availableSports.add(sport);
    notifyListeners();
  }

  void clearSports() {
    _availableSports.clear();
    notifyListeners();
  }

  Sport? _selectedMatchSport;
  Sport? get selectedMatchSport => _selectedMatchSport;
  set selectedMatchSport(Sport? value) {
    _selectedMatchSport = value;
  }

  EnumSearchStatus _searchStatus = EnumSearchStatus.NoFilterApplied;
  EnumSearchStatus get searchStatus => _searchStatus;
  set searchStatus(EnumSearchStatus value) {
    _searchStatus = value;
    notifyListeners();
  }

  int? _indexSelectedCourt; //para saber qual "agendar horario tem q ser Primary
  int? get indexSelectedCourt => _indexSelectedCourt;
  set indexSelectedCourt(int? value) {
    _indexSelectedCourt = value;
    notifyListeners();
  }

  int? _indexSelectedTime; //para saber qual horario tem que ter highlight
  int? get indexSelectedTime => _indexSelectedTime;
  set indexSelectedTime(int? value) {
    _indexSelectedTime = value;
    notifyListeners();
  }

  Court? _selectedCourt;
  Court? get selectedCourt => _selectedCourt;
  set selectedCourt(Court? value) {
    _selectedCourt = value;
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

  List<Region> _availableRegions = [];
  List<Region> get availableRegions => _availableRegions;
  void addRegion(Region region) {
    _availableRegions.add(region);
    notifyListeners();
  }

  void clearRegions() {
    _availableRegions.clear();
    notifyListeners();
  }

  void addCity(Region region, City city) {
    region.cities.add(city);
    notifyListeners();
  }

  //////////FILTROS
  Region? _selectedRegion;
  Region? get selectedRegion => _selectedRegion;
  set selectedRegion(Region? value) {
    _selectedRegion = value;
    notifyListeners();
  }

  String _regionText = "Cidade";
  String get regionText => _regionText;
  set regionText(String value) {
    _regionText = value;
    notifyListeners();
  }

  List<DateTime?> _selectedDates = [];
  List<DateTime?> get selectedDates => _selectedDates;
  set selectedDates(List<DateTime?> value) {
    _selectedDates = value;
    notifyListeners();
  }

  String _dateText = "Data";
  String get dateText => _dateText;
  set dateText(String value) {
    _dateText = value;
    notifyListeners();
  }

  TimeRangeResult? _selectedTime;
  TimeRangeResult? get selectedTime => _selectedTime;
  set selectedTime(TimeRangeResult? value) {
    _selectedTime = value;
    notifyListeners();
  }

  String _timeText = "Hora";
  String get timeText => _timeText;
  set timeText(String value) {
    _timeText = value;
    notifyListeners();
  }

  int _indexCurrentPhoto = 0;
  int get indexCurrentPhoto => _indexCurrentPhoto;
  set indexCurrentPhoto(int value) {
    _indexCurrentPhoto = value;
    notifyListeners();
  }
}
