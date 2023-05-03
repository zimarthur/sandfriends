
import 'package:sandfriends/oldApp/models/user.dart';

import '../../oldApp/models/match.dart';

class AppNotification {
  final int idNotification;
  final String message;
  final String colorString;
  final Match match;
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

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      idNotification: json['IdNotification'],
      message: json['Message'],
      colorString: json['Color'],
      match: matchFromJson(
        json['Match'],
      ),
      seen: json['Seen'],
      user: User.fromJson(
        json['User'],
      ),
    );
  }
}
