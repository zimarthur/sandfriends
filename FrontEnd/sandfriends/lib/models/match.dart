import 'package:sandfriends/models/user.dart';

import 'court.dart';
import 'match_member.dart';
import 'sport.dart';
import 'store.dart';

class Match {
  Store? _store;
  Store? get store => _store;
  set store(Store? value) {
    _store = value;
  }

  bool? _canceled;
  bool? get canceled => _canceled;
  set canceled(bool? value) {
    _canceled = value;
  }

  int? _idMatch;
  int? get idMatch => _idMatch;
  set idMatch(int? value) {
    _idMatch = value;
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

  String _userCreator = "";
  String get userCreator => _userCreator;
  set userCreator(String value) {
    _userCreator = value;
  }

  int _remainingSlots = 0;
  int get remainingSlots => _remainingSlots;
  set remainingSlots(int value) {
    _remainingSlots = value;
  }

  User? _matchCreator;
  User? get matchCreator => _matchCreator;
  set matchCreator(User? value) {
    _matchCreator = value;
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

  int _price = 0;
  int get price => _price;
  set price(int value) {
    _price = value;
  }

  String _matchUrl = "";
  String get matchUrl => _matchUrl;
  set matchUrl(String value) {
    _matchUrl = value;
  }

  String _creatorNotes = "";
  String get creatorNotes => _creatorNotes;
  set creatorNotes(String value) {
    _creatorNotes = value;
  }

  bool _isOpenMatch = false;
  bool get isOpenMatch => _isOpenMatch;
  set isOpenMatch(bool value) {
    _isOpenMatch = value;
  }

  int _maxUsers = 0;
  int get maxUsers => _maxUsers;
  set maxUsers(int value) {
    _maxUsers = value;
  }

  List<MatchMember> matchMembers = [];

  int get activeMatchMembers {
    return matchMembers
        .where((element) => element.waitingApproval == false)
        .length;
  }
}
