import 'package:flutter/material.dart';
import 'package:sandfriends/oldApp/models/region.dart';

import '../Model/Sport.dart';
import '../Model/Gender.dart';
import '../Model/Rank.dart';
import '../Model/SidePreference.dart';
import '../../oldApp/models/user.dart';

class DataProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  List<Sport> sports = [];
  List<Gender> genders = [];
  List<Rank> ranks = [];
  List<SidePreference> sidePreferences = [];

  List<Region> regions = [];
}
