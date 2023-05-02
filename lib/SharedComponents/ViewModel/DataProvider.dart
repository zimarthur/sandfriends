import 'package:flutter/material.dart';

import '../../oldApp/models/sport.dart';
import '../../oldApp/models/user.dart';

class DataProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  List<Sport> sports = [];
}
