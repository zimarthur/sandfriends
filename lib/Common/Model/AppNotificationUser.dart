import 'AppMatch/AppMatchUser.dart';
import 'Gender.dart';
import 'Hour.dart';
import 'Rank.dart';
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
    List<Rank> referenceRanks,
    List<Gender> referenceGenders,
  ) {
    return AppNotificationUser(
      idNotification: json['IdNotification'],
      message: json['Message'],
      colorString: json['Color'],
      match: AppMatchUser.fromJson(
        json['Match'],
        referenceHours,
        referenceSports,
        referenceRanks,
        referenceGenders,
      ),
      seen: json['Seen'],
      user: UserComplete.fromJson(
        json['User'],
      ),
    );
  }
}
