import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(
      Function(Map<String, dynamic>) messageCallback) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_sandfriends');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print("ARTHURDEBUG on onDidReceiveNotificationResponse");
        if (notificationResponse.payload != null) {
          print("ARTHURDEBUG 1 ${notificationResponse.payload!}");
          print("ARTHURDEBUG 2 ${json.decode(notificationResponse.payload!)}");
          print("ARTHURDEBUG 3 ${jsonDecode(notificationResponse.payload!)}");

          messageCallback(
            json.decode(notificationResponse.payload!),
          );
        }
        print(notificationResponse.payload);
      },
    );
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'sandfriends_channer_id', 'sandfriends_channel_name',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showLocalNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }
}
