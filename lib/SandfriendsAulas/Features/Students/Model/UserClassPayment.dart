import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';

class UserClassPayment {
  UserStore user;
  List<AppMatchUser> matches;

  UserClassPayment({
    required this.user,
    required this.matches,
  });
}
