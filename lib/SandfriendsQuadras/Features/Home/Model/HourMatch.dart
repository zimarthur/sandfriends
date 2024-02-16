import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';

import '../../../SharedComponents/Model/Hour.dart';

class HourMatch {
  Hour hour;
  List<AppMatch> matches;

  HourMatch({
    required this.hour,
    required this.matches,
  });
}
