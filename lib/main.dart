import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'package:sandfriends/Features/Authentication/Login/View/LoginScreen.dart';
import 'package:sandfriends/Features/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/Features/Court/View/CourtScreen.dart';
import 'package:sandfriends/Features/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Features/Home/View/HomeScreen.dart';
import 'package:sandfriends/Features/Match/View/MatchScreen.dart';
import 'package:sandfriends/Features/Onboarding/View/OnboardingScreen.dart';
import 'package:sandfriends/Features/OpenMatches/View/OpenMatchesScreen.dart';
import 'package:sandfriends/Features/RecurrentMatches/View/RecurrentMatchesSreen.dart';
import 'package:sandfriends/Features/Rewards/View/RewardsScreen.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardsUserScreen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

void handleLink(Uri uri) {
  // Do something with the incoming link.
  print('Incoming link: $uri');
}

class MyApp extends StatefulWidget {
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

        debugPrint('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
          if (_currentURI!.queryParameters['ct'] == "mtch") {
            Navigator.pushNamed(context,
                '/match?id=${_currentURI!.queryParameters['bd'].toString()}');
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
            Navigator.pushNamed(context,
                '/match?id=${initialURI.queryParameters['bd'].toString()}');
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
        onGenerateRoute: (settings) {
          String match = "/match";
          String matchSearch = "/match_search";
          String court = "/court";
          if (settings.name!.startsWith(matchSearch)) {
            final arguments = settings.arguments as Map;

            return MaterialPageRoute(
              builder: (context) {
                return MatchSearchScreen(
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
            if (settings.arguments != null) {}
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
                  selectedSport: arguments['selectedSport'] as Sport?,
                );
              },
            );
          }

          return null;
        },
        routes: {
          '/': (BuildContext context) => LoadLoginScreen(),
          '/login_signup': (BuildContext context) => LoginSignupScreen(),
          '/login': (BuildContext context) => LoginScreen(),
          '/create_account': (BuildContext context) => CreateAccountScreen(),
          '/onboarding': (BuildContext context) => OnboardingScreen(),
          '/home': (BuildContext context) => HomeScreen(
                initialTab: HomeTabs.Feed,
              ),
          '/user_details': (BuildContext context) => UserDetailsScreen(),
          '/user_matches': (BuildContext context) => UserMatchesScreen(),
          '/user_payments': (BuildContext context) => OnboardingScreen(),
          '/notifications': (BuildContext context) => NotificationsScreen(),
          '/rewards': (BuildContext context) => RewardsScreen(),
          '/rewards_user': (BuildContext context) => RewardsUserScreen(),
          '/open_matches': (BuildContext context) => OpenMatchesScreen(),
          '/recurrent_matches': (BuildContext context) =>
              RecurrentMatchesScreen(),
        },
      ),
    );
  }
}
