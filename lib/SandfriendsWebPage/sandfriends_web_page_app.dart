import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/CourtScreen.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageScreen.dart';
import '../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../Common/Model/Hour.dart';
import '../Common/Model/HourPrice/HourPriceUser.dart';
import '../Common/Model/Sport.dart';
import '../Common/Model/Store/StoreUser.dart';
import '../Sandfriends/Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import '../SandfriendsQuadras/Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';

class SandfriendsWebPageApp extends GenericApp {
  SandfriendsWebPageApp({
    required super.flavor,
  });

  @override
  String get appTitle => "Sandfriends";

  @override
  Product get product => Product.SandfriendsQuadras;

  @override
  Function(Uri link) get handleLink => (link) {};

  @override
  Function(Map<String, dynamic> data) get handleNotification => (data) {};

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        String store = '/quadras';
        String changePassword = '/cgpw'; //change password
        String emailConfirmation = '/emcf'; //email confirmation
        if (settings.name!.startsWith(store)) {
          final arguments = (settings.arguments ?? {}) as Map;
          final storeUrl = settings.name!.split("$store/")[1];
          return MaterialPageRoute(
            builder: (context) {
              return CourtScreen(
                storeUrl: storeUrl,
                store: arguments['store'] as StoreUser?,
                courtAvailableHours:
                    arguments['availableCourts'] as List<CourtAvailableHours>?,
                selectedHourPrice:
                    arguments['selectedHourPrice'] as HourPriceUser?,
                selectedDate: arguments['selectedDate'] as DateTime?,
                selectedWeekday: arguments['selectedWeekday'] as int?,
                selectedSport: arguments['selectedSport'] as Sport?,
                isRecurrent: arguments['isRecurrent'] as bool?,
                canMakeReservation: arguments['canMakeReservation'] ?? true,
                searchStartPeriod: arguments['searchStartPeriod'] as Hour?,
                searchEndPeriod: arguments['searchEndPeriod'] as Hour?,
              );
            },
          );
        } else if (settings.name!.startsWith(changePassword)) {
          String token = settings.name!.split("?")[1].split("=")[1];
          return MaterialPageRoute(
            builder: (context) {
              return ChangePasswordScreen(
                token: token,
                isStoreRequest: false,
              );
            },
          );
        } else if (settings.name!.startsWith(emailConfirmation)) {
          String token = settings.name!.split("?")[1].split("=")[1];
          return MaterialPageRoute(
            builder: (context) {
              return EmailConfirmationScreen(
                confirmationToken: token,
              );
            },
          );
        }
        return null;
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (BuildContext context) => LandingPageScreen(),
      };
}
