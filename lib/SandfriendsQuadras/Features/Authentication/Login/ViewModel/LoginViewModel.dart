import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../Menu/ViewModel/DataProvider.dart';
import '../Repository/LoginRepo.dart';

class LoginViewModel extends StandardScreenViewModel {
  final loginRepo = LoginRepo();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  bool _keepConnected = true;
  bool get keepConnected => _keepConnected;
  set keepConnected(bool newValue) {
    _keepConnected = newValue;
    notifyListeners();
  }

  Tuple2<bool, String?>? notificationsConfig;

  Future<void> configureNotifications() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("ARTHUR token is : $fcmToken");
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    bool? authorization =
        settings.authorizationStatus == AuthorizationStatus.authorized
            ? true
            : settings.authorizationStatus == AuthorizationStatus.denied
                ? false
                : null;
    notificationsConfig = authorization != null
        ? Tuple2<bool, String?>(authorization, fcmToken)
        : null;
  }

  void validateToken(BuildContext context) async {
    String? storedToken = await LocalStorageManager().getAccessToken(context);
    if (storedToken != null && storedToken.isNotEmpty) {
      loginRepo.validateToken(context, storedToken).then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<DataProvider>(context, listen: false)
              .setLoginResponse(context, response.responseBody!, keepConnected);
          Navigator.pushNamed(context, '/home');
        } else {
          pageStatus = PageStatus.OK;
          notifyListeners();
          if (!kIsWeb) {
            configureNotifications().then((notificationCOnfigs) {});
          }
        }
      });
    } else {
      pageStatus = PageStatus.OK;
      notifyListeners();
      if (!kIsWeb) {
        configureNotifications().then((notificationCOnfigs) {});
      }
    }
  }

  void onTapLogin(BuildContext context) {
    if (loginFormKey.currentState?.validate() == true) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();

      loginRepo
          .login(
        context,
        userController.text,
        passwordController.text,
        notificationsConfig,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<DataProvider>(context, listen: false)
              .setLoginResponse(context, response.responseBody!, keepConnected);
          Navigator.pushNamed(context, '/home');
        } else {
          modalMessage = SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription,
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    }
  }

  void onTapForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot_password');
  }

  void onTapCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, '/create_account');
  }
}
