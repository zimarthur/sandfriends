import 'package:flutter/material.dart';

import '../models/enums.dart';

class Match with ChangeNotifier {
  Sport? _matchSport;
  Sport? get matchSport => _matchSport;
  set matchSport(Sport? value) {
    _matchSport = value;
  }
}
