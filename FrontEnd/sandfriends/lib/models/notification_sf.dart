import 'match.dart';

class NotificationSF {
  final int idNotification;
  final String message;
  final String colorString;
  final Match match;
  final bool seen;

  NotificationSF({
    required this.idNotification,
    required this.message,
    required this.colorString,
    required this.match,
    required this.seen,
  });
}
