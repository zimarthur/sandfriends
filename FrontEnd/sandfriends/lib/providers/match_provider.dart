import 'package:flutter/material.dart';

import '../models/enums.dart';

class MatchProvider with ChangeNotifier {
  Sport? _matchSport;
  Sport? get matchSport => _matchSport;
  set matchSport(Sport? value) {
    _matchSport = value;
  }

  EnumSearchStatus _searchStatus = EnumSearchStatus.NoFilterApplied;
  EnumSearchStatus get searchStatus => _searchStatus;
  set searchStatus(EnumSearchStatus value) {
    _searchStatus = value;
  }
}
