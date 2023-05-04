import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'package:sandfriends/Authentication/Login/View/LoginScreen.dart';
import 'package:sandfriends/Authentication/LoginSignup/View/LoginSignupScreen.dart';
import 'package:sandfriends/Home/Model/HomeTabsEnum.dart';
import 'package:sandfriends/Home/View/HomeScreen.dart';
import 'package:sandfriends/Onboarding/View/OnboardingScreen.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'Authentication/LoadLogin/View/LoadLoginScreen.dart';
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
        ChangeNotifierProvider(create: (_) => DataProvider()),
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
          // String newAccountEmployee = '/create_account_employee';
          // String emailConfirmation = '/emcf';
          // String changePassword = '/cgpw';

          // if (settings.name!.startsWith(newAccountEmployee)) {
          //   return MaterialPageRoute(
          //     builder: (context) {
          //       return CreateAccountEmployeeScreen(
          //         token: settings.name!.split(newAccountEmployee)[1],
          //       );
          //     },
          //   );
          // } else if (settings.name!.startsWith(emailConfirmation)) {
          //   bool isStoreRequest = true;
          //   String token = "";
          //   final arguments = settings.name!.split("?")[1].split("&");
          //   for (var argument in arguments) {
          //     if (argument.startsWith("str")) {
          //       isStoreRequest = argument.split("=")[1] == "1";
          //     } else {
          //       token = argument.split("=")[1];
          //     }
          //   }
          //   return MaterialPageRoute(
          //     builder: (context) {
          //       return EmailConfirmationScreen(
          //         token: token,
          //         isStoreRequest: isStoreRequest,
          //       );
          //     },
          //   );
          // } else if (settings.name!.startsWith(changePassword)) {
          //   bool isStoreRequest = true;
          //   String token = "";
          //   final arguments = settings.name!.split("?")[1].split("&");
          //   for (var argument in arguments) {
          //     if (argument.startsWith("str")) {
          //       isStoreRequest = argument.split("=")[1] == "1";
          //     } else {
          //       token = argument.split("=")[1];
          //     }
          //   }
          //   return MaterialPageRoute(
          //     builder: (context) {
          //       return ChangePasswordScreen(
          //         token: token,
          //         isStoreRequest: isStoreRequest,
          //       );
          //     },
          //   );
          // }
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
        },
      ),
    );
  }
}
