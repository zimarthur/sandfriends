import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'package:sandfriends/Features/Authentication/Login/View/LoginScreen.dart';
import 'package:sandfriends/Features/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import 'package:sandfriends/Features/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Features/Home/View/HomeScreen.dart';
import 'package:sandfriends/Features/Match/View/MatchScreen.dart';
import 'package:sandfriends/Features/Onboarding/View/OnboardingScreen.dart';
import 'package:sandfriends/Features/OpenMatches/View/OpenMatchesScreen.dart';
import 'package:sandfriends/Features/RecurrentMatches/View/RecurrentMatchesSreen.dart';
import 'package:sandfriends/Features/Rewards/View/RewardsScreen.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardsUserScreen.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'Features/Authentication/LoadLogin/View/LoadLoginScreen.dart';
import 'Features/MatchSearch/View/MatchSearchScreen.dart';
import 'Features/Notifications/View/NotificationsScreen.dart';
import 'Features/UserDetails/View/UserDetailsScreen.dart';
import 'Features/UserMatches/View/UserMatchesScreen.dart';
import 'SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
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
            final match = settings.name!.split("?")[1].split("=")[1];
            return MaterialPageRoute(
              builder: (context) {
                return MatchScreen(
                  matchUrl: match,
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
