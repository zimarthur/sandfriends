import 'court.dart';
import 'sport.dart';
import 'store.dart';

class Match {
  Store? _store;
  Store? get store => _store;
  set store(Store? value) {
    _store = value;
  }

  Court? _court;
  Court? get court => _court;
  set court(Court? value) {
    _court = value;
  }

  Sport? _sport;
  Sport? get sport => _sport;
  set sport(Sport? value) {
    _sport = value;
  }

  DateTime? _day;
  DateTime? get day => _day;
  set day(DateTime? value) {
    _day = value;
  }

  String _userCreator = "sf";
  String get userCreator => _userCreator;
  set userCreator(String value) {
    _userCreator = value;
  }

  int _timeInt = 0;
  int get timeInt => _timeInt;
  set timeInt(int value) {
    _timeInt = value;
  }

  String _timeBegin = "sf";
  String get timeBegin => _timeBegin;
  set timeBegin(String value) {
    _timeBegin = value;
  }

  String _timeFinish = "sf";
  String get timeFinish => _timeFinish;
  set timeFinish(String value) {
    _timeFinish = value;
  }
}
