import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sandfriends/Common/Managers/Firebase/FirebaseOptions.dart';
import 'package:sandfriends/Common/Managers/LocalNotifications/LocalNotificationsManager.dart';
import 'package:tuple/tuple.dart';

import '../../Providers/Environment/Environment.dart';
import 'NotificationsConfig.dart';

class FirebaseManager {
  Future<void> initialize(
    Environment environment, {
    required Function(Map<String, dynamic>) messagingCallback,
  }) async {
    FirebaseOptions firebaseOption = firebaseOptions[environment.product]![
        environment.flavor]![environment.device]!;
    FirebaseApp app = await Firebase.initializeApp();
    print("firebase configured");
    print("androidClientId ${app.options.androidClientId}");
    print("apiKey ${app.options.apiKey}");
    print("appId ${app.options.appId}");
    print("iosBundleId ${app.options.iosBundleId}");
    print("iosClientId ${app.options.iosClientId}");
    print("messagingSenderId ${app.options.messagingSenderId}");
    setupCrashlytics();
    setupFirebaseMessaging(messagingCallback);
  }

  void setupCrashlytics() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  void setupFirebaseMessaging(
    Function(Map<String, dynamic>) messagingCallback,
  ) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationsManager().showLocalNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            payLoad: json.encode(message.data));
      }
    });
    if (initialMessage != null) {
      messagingCallback(initialMessage.data);
    }
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<NotificationsConfig?> configureNotifications(
      BuildContext context) async {
    String? fcmToken;
    try {
      FirebaseManager().getToken();
      fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      print("token is ${fcmToken}");
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return NotificationsConfig(
        authorizationStatus: settings.authorizationStatus,
        token: fcmToken,
      );
    } catch (e) {
      return null;
    }
  }
}
