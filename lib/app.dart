import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Features/AppInfo/View/AppInfoScreen.dart';
import 'package:sandfriends/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'package:sandfriends/Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import 'package:sandfriends/Features/Authentication/Login/View/LoginScreen.dart';
import 'package:sandfriends/Features/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import 'package:sandfriends/Features/Checkout/View/CheckoutScreen.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/Features/Court/View/CourtScreen.dart';
import 'package:sandfriends/Features/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Features/Home/View/HomeScreen.dart';
import 'package:sandfriends/Features/Match/View/MatchScreen.dart';
import 'package:sandfriends/Features/NewCreditCard/View/NewCreditCardScreen.dart';
import 'package:sandfriends/Features/Onboarding/View/OnboardingScreen.dart';
import 'package:sandfriends/Features/OpenMatches/View/OpenMatchesScreen.dart';
import 'package:sandfriends/Features/Payment/View/PaymentScreen.dart';
import 'package:sandfriends/Features/RecurrentMatchSearch/View/RecurrentMatchSearchScreen.dart';
import 'package:sandfriends/Features/RecurrentMatchSearchSport/View/RecurrentMatchSearchSportScreen.dart';
import 'package:sandfriends/Features/RecurrentMatches/View/RecurrentMatchesSreen.dart';
import 'package:sandfriends/Features/Rewards/View/RewardsScreen.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardsUserScreen.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'package:sandfriends/SharedComponents/Providers/RedirectProvider/RedirectProvider.dart';
import 'Features/Authentication/LoadLogin/View/LoadLoginScreen.dart';
import 'Features/Court/Model/CourtAvailableHours.dart';
import 'Features/MatchSearch/View/MatchSearchScreen.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';
import 'Features/UserDetails/View/UserDetailsScreen.dart';
import 'Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'Features/UserMatches/View/UserMatchesScreen.dart';
import 'SharedComponents/Model/Sport.dart';
import 'SharedComponents/Model/Store.dart';
import 'SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatefulWidget {
  final String flavor;
  const App({
    Key? key,
    required this.flavor,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialURILinkHandled = false;

  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  final environmentProvider = EnvironmentProvider();
  void _incomingLinkHandler() {
    print("_incomingLinkHandler");
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        setState(() {
          _currentURI = uri;
          _err = null;
          print("uri is ${uri}");
          if (uri != null) {
            handleUri(uri);
          }
        });
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _initURIHandler() async {
    print("_incomingLinkHandler");
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();

        if (initialURI != null) {
          if (!mounted) {
            return;
          }

          handleUri(initialURI);
        } else {}
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void handleUri(Uri handleUri) {
    if (handleUri.queryParameters['ct'] == "mtch") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return LoadLoginScreen(
              redirectUri:
                  '/match/${handleUri.queryParameters['bd'].toString()}',
            );
          },
        ),
      );
    } else if (handleUri.queryParameters['ct'] == "emcf") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return EmailConfirmationScreen(
              confirmationToken: handleUri.queryParameters['bd'].toString(),
            );
          },
        ),
      );
    }
  }

  @override
  void initState() {
    environmentProvider.setEnvironment(widget.flavor);
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RedirectProvider()),
        ChangeNotifierProvider(create: (_) => environmentProvider),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
          Locale('en'),
        ],
        locale: const Locale('pt', 'BR'),
        debugShowCheckedModeBanner: widget.flavor == "dev",
        theme: ThemeData(
            scaffoldBackgroundColor: secondaryBack,
            fontFamily: "Lexend",
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          String match = "/match";
          String matchSearch = "/match_search";
          String recurrentMatchSearch = "/recurrent_match_search";
          String court = "/court";
          String checkout = "/checkout";
          String userDetails = "/user_details";
          if (settings.name!.startsWith(matchSearch)) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return MatchSearchScreen(
                  sportId: arguments['sportId'],
                );
              },
            );
          } else if (settings.name!.startsWith(recurrentMatchSearch)) {
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
          } else if (settings.name!.startsWith(court)) {
            if (settings.arguments != null) {
              final arguments = settings.arguments as Map;

              return MaterialPageRoute(
                builder: (context) {
                  return CourtScreen(
                    store: arguments['store'] as Store,
                    courtAvailableHours: arguments['availableCourts']
                        as List<CourtAvailableHours>?,
                    selectedHourPrice:
                        arguments['selectedHourPrice'] as HourPrice?,
                    selectedDate: arguments['selectedDate'] as DateTime?,
                    selectedWeekday: arguments['selectedWeekday'] as int?,
                    selectedSport: arguments['selectedSport'] as Sport?,
                    isRecurrent: arguments['isRecurrent'] as bool?,
                  );
                },
              );
            }
          } else if (settings.name!.startsWith(checkout)) {
            if (settings.arguments != null) {
              final arguments = settings.arguments as Map;

              return MaterialPageRoute(
                builder: (context) {
                  return CheckoutScreen(
                    court: arguments['court'] as Court,
                    hourPrices: arguments['hourPrices'] as List<HourPrice>,
                    date: arguments['date'] as DateTime?,
                    weekday: arguments['weekday'] as int?,
                    sport: arguments['sport'] as Sport,
                    isRecurrent: arguments['isRecurrent'] as bool,
                    isRenovating: arguments['isRenovating'] as bool,
                  );
                },
              );
            }
          } else if (settings.name!.startsWith(userDetails)) {
            Sport? initSport;
            UserDetailsModals initModalEnum = UserDetailsModals.None;
            if (settings.arguments != null) {
              final arguments = settings.arguments as Map;

              initSport = arguments['initSport'] as Sport;
              initModalEnum =
                  arguments['userDetailsModal'] as UserDetailsModals;
            }
            return MaterialPageRoute(
              builder: (context) {
                return UserDetailsScreen(
                  initSport: initSport,
                  initModalEnum: initModalEnum,
                );
              },
            );
          }
          return null;
        },
        routes: {
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
          '/notifications': (BuildContext context) =>
              const NotificationsScreen(),
          '/rewards': (BuildContext context) => const RewardsScreen(),
          '/rewards_user': (BuildContext context) => const RewardsUserScreen(),
          '/open_matches': (BuildContext context) => const OpenMatchesScreen(),
          '/recurrent_matches': (BuildContext context) =>
              const RecurrentMatchesScreen(),
          '/recurrent_match_search_sport': (BuildContext context) =>
              const RecurrentMatchSearchSportScreen(),
          '/payment': (BuildContext context) => const PaymentScreen(),
          '/new_credit_card': (BuildContext context) =>
              const NewCreditCardScreen(),
          '/app_info': (BuildContext context) => const AppInfoScreen(),
        },
      ),
    );
  }
}
