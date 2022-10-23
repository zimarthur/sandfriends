import 'package:flutter/material.dart';
import 'package:sandfriends/models/court_available_hours.dart';
import 'package:sandfriends/models/store_day.dart';
import 'package:time_range/time_range.dart';

import '../models/city.dart';
import '../models/region.dart';
import '../models/enums.dart';
import '../models/sport.dart';
import '../models/match.dart';
import '../models/user.dart';

class MatchProvider with ChangeNotifier {
  void ResetProviderAtributes() {
    searchStatus = EnumSearchStatus.NoFilterApplied;
    _indexSelectedTime.clear();
    selectedStoreDay = null;
    _selectedTime.clear();
    _storeDayList.clear();
  }

  Sport? _selectedSport;
  Sport? get selectedSport => _selectedSport;
  set selectedSport(Sport? value) {
    _selectedSport = value;
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

  List<int> _indexSelectedTime =
      []; //para saber qual horario tem que ter highlight
  List<int> get indexSelectedTime => _indexSelectedTime;
  set indexSelectedTime(List<int> value) {
    _indexSelectedTime = value;
    notifyListeners();
  }

  StoreDay? _selectedStoreDay;
  StoreDay? get selectedStoreDay => _selectedStoreDay;
  set selectedStoreDay(StoreDay? value) {
    _selectedStoreDay = value;
    notifyListeners();
  }

  List<CourtAvailableHours> _selectedTime = [];
  List<CourtAvailableHours> get selectedTime => _selectedTime;
  set selectedTime(List<CourtAvailableHours> value) {
    _selectedTime = value;
    notifyListeners();
  }

  List<StoreDay> _storeDayList = [];
  List<StoreDay> get storeDayList => _storeDayList;
  void addStoreDay(StoreDay storeDay) {
    _storeDayList.add(storeDay);
    notifyListeners();
  }

  void clearStoreDayList() {
    _storeDayList.clear();
    notifyListeners();
  }

  List<Match> _openMatchList = [];
  List<Match> get openMatchList => _openMatchList;
  void addOpenMatch(Match match) {
    _openMatchList.add(match);
    notifyListeners();
  }

  void clearOpenMatchList() {
    _openMatchList.clear();
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

  TimeRangeResult? _selectedTimeRange;
  TimeRangeResult? get selectedTimeRange => _selectedTimeRange;
  set selectedTimeRange(TimeRangeResult? value) {
    _selectedTimeRange = value;
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

  RangeValues _currentSlider = const RangeValues(0, 23);
  RangeValues get currentSlider => _currentSlider;
  set currentSlider(RangeValues values) {
    _currentSlider = values;
    notifyListeners();
  }

  // MATCH DETAILS
  String get matchDetailsTime {
    return "${selectedTime.first.hour} - ${selectedTime.last.hourFinish}";
  }

  int get matchDetailsPrice {
    int totalPrice = 0;
    for (int i = 0; i < selectedTime.length; i++) {
      totalPrice += selectedTime[i].price;
    }
    return totalPrice;
  }

  String get matchDetailsCourt {
    return selectedStoreDay!.courts[indexSelectedCourt!].storeCourtName;
  }

  bool _needsRefresh = false;
  bool get needsRefresh => _needsRefresh;
  set needsRefresh(bool value) {
    _needsRefresh = value;
  }
}
