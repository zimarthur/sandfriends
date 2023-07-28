import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
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
import 'package:sandfriends/SharedComponents/Providers/RedirectProvider/RedirectProvider.dart';
import 'Features/Authentication/LoadLogin/View/LoadLoginScreen.dart';
import 'Features/Court/Model/CourtAvailableHours.dart';
import 'Features/MatchSearch/View/MatchSearchScreen.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';
import 'Features/UserDetails/View/UserDetailsScreen.dart';
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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(const MyApp());
  });
}

void handleLink(Uri uri) {
  // Do something with the incoming link.
  print('Incoming link: $uri');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialURILinkHandled = false;

  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        setState(() {
          _currentURI = uri;
          _err = null;
          if (_currentURI!.queryParameters['ct'] == "mtch") {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) {
                  return LoadLoginScreen(
                    redirectUri:
                        '/match/${_currentURI!.queryParameters['bd'].toString()}',
                  );
                },
              ),
            );
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
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();

        if (initialURI != null) {
          if (!mounted) {
            return;
          }

          if (initialURI.queryParameters['ct'] == "mtch") {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) {
                  return LoadLoginScreen(
                    redirectUri:
                        '/match/${initialURI.queryParameters['bd'].toString()}',
                  );
                },
              ),
            );
          }
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

  @override
  void initState() {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RedirectProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
          Locale('en'),
        ],
        locale: const Locale('pt', 'BR'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: secondaryBack,
          fontFamily: "Lexend",
        ),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          String match = "/match";
          String matchSearch = "/match_search";
          String recurrentMatchSearch = "/recurrent_match_search";
          String court = "/court";
          String checkout = "/checkout";
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
            List<CourtAvailableHours>? courtAvailableHours;
            HourPrice? hourPrice;
            DateTime? datetime;
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
          }
          return null;
        },
        routes: {
          '/': (BuildContext context) => LoadLoginScreen(),
          '/login_signup': (BuildContext context) => const LoginSignupScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
          '/create_account': (BuildContext context) =>
              const CreateAccountScreen(),
          '/onboarding': (BuildContext context) => const OnboardingScreen(),
          '/home': (BuildContext context) => HomeScreen(
                initialTab: HomeTabs.Feed,
              ),
          '/user_details': (BuildContext context) => const UserDetailsScreen(),
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
        },
      ),
    );
  }
}
