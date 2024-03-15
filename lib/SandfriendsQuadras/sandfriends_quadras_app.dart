import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Settings/View/Mobile/SettingsScreenMobile.dart';

import 'Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';
import 'Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'Features/Authentication/CreateAccountEmployee/View/CreateAccountEmployeeScreen.dart';
import 'Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import 'Features/Authentication/ForgotPassword/View/ForgotPasswordScreen.dart';
import 'Features/Authentication/Login/View/LoginScreen.dart';
import 'Features/Menu/View/MenuScreen.dart';
import 'Features/Menu/ViewModel/StoreProvider.dart';
import 'Features/Menu/ViewModel/MenuProvider.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';

class SandfriendsQuadrasApp extends GenericApp {
  SandfriendsQuadrasApp({required super.flavor});

  @override
  String get appTitle => "Sandfriends Quadras";

  @override
  Product get product => Product.SandfriendsQuadras;

  @override
  MaterialPageRoute? Function(Uri) get handleLink => (link) {};

  @override
  Uri? Function(Map<String, dynamic> data) get handleNotification => (data) {};

  @override
  String? get initialRoute => '/login';

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        String newAccountEmployee = '/novo-funcionario/'; //add employee
        String emailConfirmation = '/confirme-seu-email/'; //email confirmation
        String changePassword = '/troca-senha/'; //change password
        if (settings.name!.startsWith(newAccountEmployee)) {
          return MaterialPageRoute(
            builder: (context) {
              return CreateAccountEmployeeScreen(
                token: settings.name!.split(newAccountEmployee)[1],
              );
            },
          );
        } else if (settings.name!.startsWith(emailConfirmation)) {
          return MaterialPageRoute(
            builder: (context) {
              return EmailConfirmationScreen(
                token: settings.name!.split(emailConfirmation)[1],
                isStoreRequest: true,
              );
            },
          );
        } else if (settings.name!.startsWith(changePassword)) {
          return MaterialPageRoute(
            builder: (context) {
              return ChangePasswordScreen(
                token: settings.name!.split(changePassword)[1],
                isStoreRequest: true,
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
        '/settings': (BuildContext context) => SettingsScreenMobile(),
      };
}
