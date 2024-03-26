import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';
import '../Repository/LoginRepo.dart';

class LoginViewModel extends ChangeNotifier {
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
    print("token is : $fcmToken");
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
    if (Provider.of<EnvironmentProvider>(context, listen: false)
        .environment
        .isDev) {
      userController.text = "sandquadras@gmail.com";
      passwordController.text = "aaaaaaaa";
    }
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    String? storedToken = await LocalStorageManager().getAccessToken(context);
    if (storedToken != null && storedToken.isNotEmpty) {
      loginRepo.validateToken(context, storedToken).then((response) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<StoreProvider>(context, listen: false)
              .setLoginResponse(context, response.responseBody!, keepConnected);
          Navigator.pushNamed(context, '/home');
        } else {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
          if (!kIsWeb) {
            configureNotifications().then((notificationCOnfigs) {});
          }
        }
      });
    } else {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (!kIsWeb) {
        configureNotifications().then((notificationCOnfigs) {});
      }
    }
  }

  void onTapLogin(BuildContext context) {
    if (loginFormKey.currentState?.validate() == true) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

      loginRepo
          .login(
        context,
        userController.text,
        passwordController.text,
        notificationsConfig,
      )
          .then((response) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<StoreProvider>(context, listen: false)
              .setLoginResponse(context, response.responseBody!, keepConnected);
          Navigator.pushNamed(context, '/home');
        } else {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addModalMessage(
            SFModalMessage(
              title: response.responseTitle!,
              description: response.responseDescription,
              onTap: () {},
              isHappy: response.responseStatus == NetworkResponseStatus.alert,
            ),
          );
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
