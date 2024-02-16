import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandfriends_web/Features/Authentication/ChangePassword/View/ChangePasswordScreen.dart';
import 'package:sandfriends_web/Features/Authentication/CreateAccount/View/CreateAccountScreen.dart';
import 'package:sandfriends_web/Features/Authentication/EmailConfirmation/View/EmailConfirmationScreen.dart';
import 'package:sandfriends_web/Features/Authentication/ForgotPassword/View/ForgotPasswordScreen.dart';
import 'package:sandfriends_web/Features/Notifications/View/NotificationsScreen.dart';
import 'package:sandfriends_web/Features/Rewards/ViewModel/RewardsViewModel.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/MenuProvider.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/Features/Authentication/Login/View/LoginScreen.dart';
import 'Features/Authentication/CreateAccountEmployee/View/CreateAccountEmployeeScreen.dart';
import 'Features/Menu/View/MenuScreen.dart';
import 'SharedComponents/ViewModel/EnvironmentProvider.dart';
import 'Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notifications.dart';

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
  final environmentProvider = EnvironmentProvider();
  @override
  void initState() {
    environmentProvider.setEnvironment(widget.flavor);
    if (!kIsWeb) {
      setupFirebaseMessaging();
      NotificationService().initNotification(_handleMessage);
    }
    super.initState();
  }

  void _handleMessage(Map<String, dynamic> data) {}

  Future<void> setupFirebaseMessaging() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService().showLocalNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            payLoad: json.encode(message.data));
      }
    });
    if (initialMessage != null) {
      _handleMessage(initialMessage.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
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
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        title: 'Sandfriends',
        theme: ThemeData(
          scaffoldBackgroundColor: secondaryBack,
          fontFamily: "Lexend",
        ),
        onGenerateRoute: (settings) {
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
        },
        routes: {
          //'/new_password': (BuildContext context) => const NewPasswordScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
          '/create_account': (BuildContext context) =>
              const CreateAccountScreen(),
          '/forgot_password': (BuildContext context) =>
              const ForgotPasswordScreen(),
          '/home': (BuildContext context) => const MenuScreen(),
          '/notifications': (BuildContext context) => NotificationsScreen(),
        },
        initialRoute: '/login',
      ),
    );
  }
}
