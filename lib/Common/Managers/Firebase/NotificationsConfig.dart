import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsConfig {
  AuthorizationStatus authorizationStatus;
  String? token;

  bool get authorized => authorizationStatus == AuthorizationStatus.authorized;

  NotificationsConfig({
    required this.authorizationStatus,
    required this.token,
  });
}
