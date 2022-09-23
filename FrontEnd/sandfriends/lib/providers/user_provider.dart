import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/match.dart';
import '../models/match.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
  }

  List<Match> _matchList = [];
  List<Match> get matchList {
    _matchList.sort(
      (a, b) {
        int compare = a.day!.compareTo(b.day!);

        if (compare == 0) {
          return a.timeInt.compareTo(b.timeInt);
        } else {
          return compare;
        }
      },
    );
    _matchList.sort(((a, b) => a.day!.compareTo(b.day!)));
    for (int i = 0; i < _matchList.length; i++) {
      print(_matchList[i].day);
    }
    return _matchList;
  }

  void addMatch(Match newMatch) {
    _matchList.add(newMatch);
  }

  void clearMatchList() {
    _matchList.clear();
  }

  bool _nextMatchNeedsRefresh = false;
  bool get nextMatchNeedsRefresh => _nextMatchNeedsRefresh;
  set nextMatchNeedsRefresh(bool value) {
    _nextMatchNeedsRefresh = value;
  }

  void userFromJson(Map<String, dynamic> json) {
    var newUser = User();
    newUser.IdUser = json['IdUser'];
    newUser.FirstName = json['FirstName'];
    newUser.LastName = json['LastName'];
    newUser.Gender = json['Gender'];
    newUser.PhoneNumber = json['PhoneNumber'];
    newUser.Birthday = json['Birthday'];
    newUser.Age = json['Age'];
    newUser.Rank = json['Rank'];
    newUser.Height = json['Height'];
    newUser.HandPreference = json['HandPreference'];
    newUser.Photo = json['Photo'];

    user = newUser;
  }
}
