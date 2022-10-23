import 'package:sandfriends/models/user.dart';

import 'match.dart';

class NotificationSF {
  final int idNotification;
  final String message;
  final String colorString;
  final Match match;
  final bool seen;
  final User user;

  NotificationSF({
    required this.idNotification,
    required this.message,
    required this.colorString,
    required this.match,
    required this.seen,
    required this.user,
  });
}

NotificationSF notificationFromJson(Map<String, dynamic> json) {
  var newNotification = NotificationSF(
    idNotification: json['IdNotification'],
    message: json['Message'],
    colorString: json['Color'],
    match: matchFromJson(
      json['Match'],
    ),
    seen: json['Seen'],
    user: userFromJson(
      json['User'],
    ),
  );
  return newNotification;
}
