import 'package:sandfriends/models/court_available_hours.dart';

import 'court.dart';
import 'store.dart';

class StoreDay {
  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = value;
  }

  Store _store = Store();
  Store get store => _store;
  set store(Store value) {
    _store = value;
  }

  String _day = "sf";
  String get day => _day;
  set day(String value) {
    _day = value;
  }

  List<Court> courts = [];
}
