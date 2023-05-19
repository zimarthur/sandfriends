import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';

import '../../../Utils/PageStatus.dart';

class RecurrentMatchSearchSportViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;

  void onSportSelected(BuildContext context, Sport sport) {
    Navigator.pushNamed(context, '/recurrent_match_search', arguments: {
      'sportId': sport.idSport,
    });
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
