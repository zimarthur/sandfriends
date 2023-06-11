import 'package:sandfriends/SharedComponents/Model/User.dart';

import 'AppMatch.dart';
import 'Hour.dart';
import 'Sport.dart';

class AppNotification {
  final int idNotification;
  final String message;
  final String colorString;
  final AppMatch match;
  bool seen;
  final User user;

  AppNotification({
    required this.idNotification,
    required this.message,
    required this.colorString,
    required this.match,
    required this.seen,
    required this.user,
  });

  factory AppNotification.fromJson(
    Map<String, dynamic> json,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    return AppNotification(
      idNotification: json['IdNotification'],
      message: json['Message'],
      colorString: json['Color'],
      match: AppMatch.fromJson(
        json['Match'],
        referenceHours,
        referenceSports,
      ),
      seen: json['Seen'],
      user: User.fromJson(
        json['User'],
      ),
    );
  }
}
