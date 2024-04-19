import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/CourtScreen.dart';
import 'package:sandfriends/Common/Features/UserDetails/View/UserDetailsScreen.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageScreen.dart';
import '../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../Common/Features/Match/View/MatchScreen.dart';
import '../Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import '../Common/Features/UserMatches/View/UserMatchesScreen.dart';
import '../Common/Model/Court.dart';
import '../Common/Model/Hour.dart';
import '../Common/Model/HourPrice/HourPriceUser.dart';
import '../Common/Model/Sport.dart';
import '../Common/Model/Store/StoreUser.dart';
import '../Common/Model/Team.dart';
import '../Sandfriends/Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import '../Sandfriends/Features/Checkout/View/CheckoutScreen.dart';
import '../SandfriendsQuadras/Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';

class SandfriendsWebPageApp extends GenericApp {
  SandfriendsWebPageApp({
    required super.flavor,
  });

  @override
  String get appTitle => "Sandfriends";

  @override
  Product get product => Product.SandfriendsWebPage;

  @override
  MaterialPageRoute? Function(Uri) get handleLink => (link) {};

  @override
  Uri? Function(Map<String, dynamic> data) get handleNotification => (data) {};

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        String store = '/quadra/';
        String changePassword = '/troca-senha/'; //change password
        String emailConfirmation = "/confirme-seu-email/"; //email confirmation
        String userDetails = "/jogador";
        String match = "/partida/";
        String checkout = "/checkout";
        if (settings.name!.startsWith(store)) {
          final arguments = (settings.arguments ?? {}) as Map;
          final storeUrl = settings.name!.split(store);
          if (storeUrl.length == 1) {
            return null;
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return CourtScreen(
                storeUrl: storeUrl[1],
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
        } else if (settings.name!.startsWith(match)) {
          //partida/1234
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return MatchScreen(
                matchUrl: settings.name!.split(match)[1],
              );
            },
          );
        } else if (settings.name!.startsWith(changePassword)) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return ChangePasswordScreen(
                token: settings.name!.split(changePassword)[1],
                isStoreRequest: false,
              );
            },
          );
        } else if (settings.name!.startsWith(emailConfirmation)) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return EmailConfirmationScreen(
                confirmationToken: settings.name!.split(emailConfirmation)[1],
              );
            },
          );
        } else if (settings.name! == userDetails) {
          Sport? initSport;
          UserDetailsModals initModalEnum = UserDetailsModals.None;
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            initSport = arguments['initSport'] as Sport;
            initModalEnum = arguments['userDetailsModal'] as UserDetailsModals;
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return UserDetailsScreen(
                initSport: initSport,
                initModalEnum: initModalEnum,
              );
            },
          );
        } else if (settings.name! == checkout) {
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return CheckoutScreen(
                  court: arguments['court'] as Court,
                  hourPrices: arguments['hourPrices'] as List<HourPriceUser>,
                  date: arguments['date'] as DateTime?,
                  weekday: arguments['weekday'] as int?,
                  sport: arguments['sport'] as Sport,
                  isRecurrent: arguments['isRecurrent'] as bool,
                  isRenovating: arguments['isRenovating'] as bool,
                  team: arguments['team'] as Team?,
                );
              },
            );
          }
        }
        return null;
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (BuildContext context) => LandingPageScreen(),
        '/partidas': (BuildContext context) => const UserMatchesScreen(),
      };
}
