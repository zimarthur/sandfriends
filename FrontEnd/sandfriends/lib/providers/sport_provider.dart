import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/sport.dart';

class SportProvider with ChangeNotifier {
  List<Sport> _sports = [];
  List<Sport> get sports => _sports;
  void addSport(Sport sport) {
    bool isNewSport = true;
    for (int i = 0; i < _sports.length; i++) {
      if (_sports[i].idSport == sport.idSport) {
        isNewSport = false;
        break;
      }
    }
    if (isNewSport) {
      _sports.add(sport);
      notifyListeners();
    }
  }

  void clearStores() {
    _sports.clear();
    notifyListeners();
  }
}
