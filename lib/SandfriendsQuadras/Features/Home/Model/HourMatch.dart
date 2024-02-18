import 'package:sandfriends/Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../Common/Model/Hour.dart';

class HourMatch {
  Hour hour;
  List<AppMatchStore> matches;

  HourMatch({
    required this.hour,
    required this.matches,
  });
}
