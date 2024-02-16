import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';

import 'Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';
import 'Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'Features/Authentication/CreateAccountEmployee/View/CreateAccountEmployeeScreen.dart';
import 'Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import 'Features/Authentication/ForgotPassword/View/ForgotPasswordScreen.dart';
import 'Features/Authentication/Login/View/LoginScreen.dart';
import 'Features/Menu/View/MenuScreen.dart';
import 'Features/Menu/ViewModel/DataProvider.dart';
import 'Features/Menu/ViewModel/MenuProvider.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';

class SandfriendsQuadrasApp extends GenericApp {
  SandfriendsQuadrasApp({required super.flavor});

  @override
  String get appTitle => "Sandfriends Quadras";

  @override
  Product get product => Product.SandfriendsQuadras;

  @override
  Function(Uri link) get handleLink => (link) {};

  @override
  Function(Map<String, dynamic> data) get handleNotification => (data) {};

  @override
  List<ChangeNotifier> get providers => [
        MenuProvider(),
        DataProvider(),
      ];

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        String newAccountEmployee = '/adem'; //add employee
        String emailConfirmation = '/emcf'; //email confirmation
        String changePassword = '/cgpw'; //change password
        if (settings.name!.startsWith(newAccountEmployee)) {
          final token = settings.name!.split("?")[1].split("=")[1];
          return MaterialPageRoute(
            builder: (context) {
              return CreateAccountEmployeeScreen(
                token: token,
              );
            },
          );
        } else if (settings.name!.startsWith(emailConfirmation)) {
          bool isStoreRequest = true;
          String token = "";
          final arguments = settings.name!.split("?")[1].split("&");
          for (var argument in arguments) {
            if (argument.startsWith("str")) {
              isStoreRequest = argument.split("=")[1] == "1";
            } else {
              token = argument.split("=")[1];
            }
          }
          return MaterialPageRoute(
            builder: (context) {
              return EmailConfirmationScreen(
                token: token,
                isStoreRequest: isStoreRequest,
              );
            },
          );
        } else if (settings.name!.startsWith(changePassword)) {
          bool isStoreRequest = true;
          String token = "";
          final arguments = settings.name!.split("?")[1].split("&");
          for (var argument in arguments) {
            if (argument.startsWith("str")) {
              isStoreRequest = argument.split("=")[1] == "1";
            } else {
              token = argument.split("=")[1];
            }
          }
          return MaterialPageRoute(
            builder: (context) {
              return ChangePasswordScreen(
                token: token,
                isStoreRequest: isStoreRequest,
              );
            },
          );
        }
        return null;
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/login': (BuildContext context) => const LoginScreen(),
        '/create_account': (BuildContext context) =>
            const CreateAccountScreen(),
        '/forgot_password': (BuildContext context) =>
            const ForgotPasswordScreen(),
        '/home': (BuildContext context) => const MenuScreen(),
        '/notifications': (BuildContext context) => NotificationsScreen(),
      };
}
