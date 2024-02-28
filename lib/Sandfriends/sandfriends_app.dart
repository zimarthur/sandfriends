import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import '../Common/Model/City.dart';
import '../Common/Model/Court.dart';
import '../Common/Model/Hour.dart';
import '../Common/Model/Sport.dart';
import 'Providers/RedirectProvider/RedirectProvider.dart';
import 'Providers/UserProvider/UserProvider.dart';
import 'Features/AppInfo/View/AppInfoScreen.dart';
import 'Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import 'Features/Authentication/LoadLogin/View/LoadLoginScreen.dart';
import 'Features/Authentication/Login/View/LoginScreen.dart';
import 'Features/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import 'Features/Checkout/View/CheckoutScreen.dart';
import '../Common/Features/Court/Model/CourtAvailableHours.dart';
import '../Common/Model/HourPrice/HourPriceUser.dart';
import '../Common/Features/Court/View/CourtScreen.dart';
import 'Features/Home/Model/HomeTabsEnum.dart';
import 'Features/Home/View/HomeScreen.dart';
import 'Features/Match/View/MatchScreen.dart';
import 'Features/MatchSearch/View/MatchSearchScreen.dart';
import 'Features/MatchSearchFilter/Model/CustomFilter.dart';
import 'Features/MatchSearchFilter/View/MatchSearchFilterScreen.dart';
import 'Features/NewCreditCard/View/NewCreditCardScreen.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';
import 'Features/Onboarding/View/OnboardingScreen.dart';
import 'Features/OpenMatches/View/OpenMatchesScreen.dart';
import 'Features/Payment/View/PaymentScreen.dart';
import 'Features/RecurrentMatchSearch/View/RecurrentMatchSearchScreen.dart';
import 'Features/RecurrentMatches/View/RecurrentMatchesSreen.dart';
import 'Features/Rewards/View/RewardsScreen.dart';
import 'Features/RewardsUser/View/RewardsUserScreen.dart';
import 'Features/SearchType/View/SearchTypeScreen.dart';
import 'Features/StoreSearch/View/StoreSearchScreen.dart';
import 'Features/UserDetails/View/UserDetailsScreen.dart';
import 'Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'Features/UserMatches/View/UserMatchesScreen.dart';

class SandfriendsApp extends GenericApp {
  SandfriendsApp({
    super.key,
    required super.flavor,
  });

  @override
  String get appTitle => "Sandfriends";
  @override
  Product get product => Product.Sandfriends;

  @override
  Function(Uri uri) get handleLink => (uri) {
        if (uri.queryParameters['ct'] == "mtch") {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return LoadLoginScreen(
                  redirectUri: '/match/${uri.queryParameters['bd'].toString()}',
                );
              },
            ),
          );
        } else if (uri.queryParameters['ct'] == "emcf") {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return EmailConfirmationScreen(
                  confirmationToken: uri.queryParameters['bd'].toString(),
                );
              },
            ),
          );
        } else if (uri.path.startsWith("/quadra")) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) {
                return LoadLoginScreen(
                  redirectUri: uri.path,
                );
              },
            ),
          );
        }
      };

  @override
  Function(Map<String, dynamic> data) get handleNotification => (data) {
        switch (data["type"]) {
          case "match":
            handleLink(Uri.dataFromString(
                "https://sandfriends.com.br/redirect/?ct=mtch&bd=${data["matchUrl"]}"));

            break;
          default:
        }
      };

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        String match = "/match";
        String matchSearch = "/match_search";
        String matchSearchFilter = "/match_search_filter";
        String recurrentMatchSearch = "/recurrent_match_search";
        String court = "/quadras";
        String checkout = "/checkout";
        String userDetails = "/user_details";
        String storeSearch = "/store_search";
        String searchType = "/search_type";
        if (settings.name! == matchSearch) {
          final arguments = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return MatchSearchScreen(
                sportId: arguments['sportId'],
              );
            },
          );
        } else if (settings.name! == matchSearchFilter) {
          final arguments = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return MatchSearchFilterScreen(
                defaultCustomFilter:
                    arguments['defaultCustomFilter'] as CustomFilter,
                currentCustomFilter:
                    arguments['currentCustomFilter'] as CustomFilter,
                selectedCityId: arguments['selectedCityId'] as City?,
                hideOrderBy: arguments['hideOrderBy'] as bool?,
                isRecurrent: arguments['isRecurrent'] as bool,
              );
            },
          );
        } else if (settings.name! == recurrentMatchSearch) {
          final arguments = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return RecurrentMatchSearchScreen(
                sportId: arguments['sportId'],
              );
            },
          );
        } else if (settings.name!.startsWith(match)) {
          //match?id=123
          final matchUrl = settings.name!.split(match)[1].split("/")[1];
          return MaterialPageRoute(
            builder: (context) {
              return MatchScreen(
                matchUrl: matchUrl,
              );
            },
          );
        }
        // else if (settings.name!.startsWith(courtRedirect)) {
        //   final storeId = settings.name!.split(court)[1].split("/")[1];
        //   return MaterialPageRoute(
        //     builder: (context) {
        //       return CourtScreen(
        //         canMakeReservation: true,
        //         idStore: storeId,
        //       );
        //     },
        //   );
        // }
        else if (settings.name!.startsWith(court)) {
          final storeUrl = settings.name!.split("$court/")[1];
          final arguments = (settings.arguments ?? {}) as Map;

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
                canMakeReservation: arguments['canMakeReservation'] ?? false,
                searchStartPeriod: arguments['searchStartPeriod'] as Hour?,
                searchEndPeriod: arguments['searchEndPeriod'] as Hour?,
              );
            },
          );
        } else if (settings.name! == checkout) {
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return CheckoutScreen(
                  court: arguments['court'] as Court,
                  hourPrices: arguments['hourPrices'] as List<HourPriceUser>,
                  date: arguments['date'] as DateTime?,
                  weekday: arguments['weekday'] as int?,
                  sport: arguments['sport'] as Sport,
                  isRecurrent: arguments['isRecurrent'] as bool,
                  isRenovating: arguments['isRenovating'] as bool,
                );
              },
            );
          }
        } else if (settings.name! == userDetails) {
          Sport? initSport;
          UserDetailsModals initModalEnum = UserDetailsModals.None;
          if (settings.arguments != null) {
            final arguments = settings.arguments as Map;

            initSport = arguments['initSport'] as Sport;
            initModalEnum = arguments['userDetailsModal'] as UserDetailsModals;
          }
          return MaterialPageRoute(
            builder: (context) {
              return UserDetailsScreen(
                initSport: initSport,
                initModalEnum: initModalEnum,
              );
            },
          );
        } else if (settings.name! == storeSearch) {
          final arguments = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return StoreSearchScreen(
                sportId: arguments['sportId'],
                isRecurrent: arguments['isRecurrent'],
              );
            },
          );
        } else if (settings.name! == searchType) {
          final arguments = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) {
              return SearchTypeScreen(
                isRecurrent: arguments['isRecurrent'] as bool,
                showReturnArrow: arguments['showReturnArrow'] ?? false,
              );
            },
          );
        }
        return null;
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (BuildContext context) => const LoadLoginScreen(),
        '/login_signup': (BuildContext context) => const LoginSignupScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/create_account': (BuildContext context) =>
            const CreateAccountScreen(),
        '/onboarding': (BuildContext context) => const OnboardingScreen(),
        '/home': (BuildContext context) => const HomeScreen(
              initialTab: HomeTabs.Feed,
            ),
        '/user_matches': (BuildContext context) => const UserMatchesScreen(),
        '/user_payments': (BuildContext context) => const OnboardingScreen(),
        '/notifications': (BuildContext context) => const NotificationsScreen(),
        '/rewards': (BuildContext context) => const RewardsScreen(),
        '/rewards_user': (BuildContext context) => const RewardsUserScreen(),
        '/open_matches': (BuildContext context) => const OpenMatchesScreen(),
        '/recurrent_matches': (BuildContext context) =>
            const RecurrentMatchesScreen(),
        '/payment': (BuildContext context) => const PaymentScreen(),
        '/new_credit_card': (BuildContext context) =>
            const NewCreditCardScreen(),
        '/app_info': (BuildContext context) => const AppInfoScreen(),
      };
}
