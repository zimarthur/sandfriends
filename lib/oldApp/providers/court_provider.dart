import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../SharedComponents/Model/Court.dart';

class CourtProvider with ChangeNotifier {
  final List<Court> _courts = [];
  List<Court> get courts => _courts;
  void addCourt(Court court) {
    bool isNewCourt = true;
    for (int i = 0; i < _courts.length; i++) {
      if (_courts[i].idStoreCourt == court.idStoreCourt) {
        isNewCourt = false;
        break;
      }
    }
    if (isNewCourt) {
      _courts.add(court);
      notifyListeners();
    }
  }

  void clearCourts() {
    _courts.clear();
    notifyListeners();
  }
}
