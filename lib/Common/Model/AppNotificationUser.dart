import 'package:sandfriends/Common/Model/User/UserOld.dart';
import 'AppMatch/AppMatchUser.dart';
import 'Hour.dart';
import 'Sport.dart';
import 'User/UserComplete.dart';

class AppNotificationUser {
  final int idNotification;
  final String message;
  final String colorString;
  final AppMatchUser match;
  bool seen;
  final UserComplete user;

  AppNotificationUser({
    required this.idNotification,
    required this.message,
    required this.colorString,
    required this.match,
    required this.seen,
    required this.user,
  });

  factory AppNotificationUser.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    return AppNotificationUser(
      idNotification: json['IdNotification'],
      message: json['Message'],
      colorString: json['Color'],
      match: AppMatchUser.fromJson(
        json['Match'],
        referenceHours,
        referenceSports,
      ),
      seen: json['Seen'],
      user: UserComplete.fromJson(
        json['User'],
      ),
    );
  }
}
