import 'package:flutter/material.dart';
import 'package:sandfriends/oldApp/models/court_available_hours.dart';
import 'package:sandfriends/oldApp/models/recurrent_match.dart';
import 'package:sandfriends/oldApp/models/store_day.dart';
import 'package:time_range/time_range.dart';

import '../models/city.dart';
import '../models/region.dart';
import '../models/enums.dart';
import '../models/sport.dart';
import '../models/match.dart';

class RecurrentMatchProvider with ChangeNotifier {
  void ResetProviderAtributes() {
    searchStatus = EnumSearchStatus.NoFilterApplied;

    selectedStoreDay = null;
    _selectedTime.clear();
    _storeDayList.clear();
  }

  List<RecurrentMatch> recurrentMatchesList = [];

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

  int _startingHourCourt = 0;
  int get startingHourCourt => _startingHourCourt;
  set startingHourCourt(int value) {
    _startingHourCourt = value;
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

  final List<StoreDay> _storeDayList = [];
  List<StoreDay> get storeDayList => _storeDayList;
  void addStoreDay(StoreDay storeDay) {
    _storeDayList.add(storeDay);
    notifyListeners();
  }

  void clearStoreDayList() {
    _storeDayList.clear();
    notifyListeners();
  }

  final List<Match> _openMatchList = [];
  List<Match> get openMatchList => _openMatchList;
  void addOpenMatch(Match match) {
    _openMatchList.add(match);
    notifyListeners();
  }

  void clearOpenMatchList() {
    _openMatchList.clear();
    notifyListeners();
  }

  final List<Region> _availableRegions = [];
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

  final List<int> _selectedDays = [];
  List<int> get selectedDays {
    _selectedDays.sort();
    return _selectedDays;
  }

  void clickedDay(int value) {
    if (_selectedDays.contains(value)) {
      _selectedDays.remove(value);
    } else {
      _selectedDays.add(value);
    }
    notifyListeners();
  }

  String _dayText = "Dia";
  String get dayText => _dayText;
  set dayText(String value) {
    _dayText = value;
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

  int get matchDetailsCourt {
    return selectedStoreDay!.courts[indexSelectedCourt!].idStoreCourt;
  }

  bool _needsRefresh = false;
  bool get needsRefresh => _needsRefresh;
  set needsRefresh(bool value) {
    _needsRefresh = value;
  }
}