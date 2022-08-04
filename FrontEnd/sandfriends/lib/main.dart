import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/screens/login/dummy.dart';
import './providers/redirect_provider.dart';
import './screens/login/change_password.dart';
import 'package:sandfriends/screens/login/email_validation.dart';
import 'package:uni_links/uni_links.dart';
import '../api/google_signin_api.dart';
import 'dart:async';

import 'models/enums.dart';
import 'screens/login/create_account.dart';
import 'screens/login/new_user_form.dart';
import 'screens/login/new_user_welcome.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/login_signup_screen.dart';
import '../screens/home_screen.dart';
import 'screens/login/load_login_screen.dart';
import '../screens/user_detail_screen.dart';
import './theme/app_theme.dart';
import './providers/login_provider.dart';
import 'models/user.dart';

final redirecter = Redirect();
final loginInfo = Login();
final userinfo = User();

bool needsRedirect = false;
bool? isAppInit;

bool _initialUriIsHandled = false;

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  StreamSubscription? _sub;

  //   // NOTE: Don't forget to call _sub.cancel() in dispose()
  // }
  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          needsRedirect = true;
          redirecter.redirect = uri;
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      print('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
          isAppInit = false;
          redirecter.redirect = null;
        } else {
          print('got initial uri: $uri');
          needsRedirect = true;
          redirecter.redirect = uri;
        }
        if (!mounted) {
          print("not mounteeeeed");
          return;
        }
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //initUniLinks();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Redirect>.value(
          value: redirecter,
        ),
        ChangeNotifierProvider<Login>.value(
          value: loginInfo,
        ),
        ChangeNotifierProvider<User>.value(
          value: userinfo,
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.define(),
      ),
    );
  }

  final GoRouter _router = GoRouter(
    refreshListenable: redirecter,
    redirect: (state) {
      if (needsRedirect) {
        needsRedirect = false;
        Uri receivedUri = redirecter.redirect!;
        if (receivedUri.queryParameters['ct'] == "emcf") {
          loginInfo.emailConfirmationToken =
              receivedUri.queryParameters['bd'].toString();
          return '/email_validation';
        } else if (receivedUri.queryParameters['ct'] == "cgpw") {
          loginInfo.changePasswordToken =
              receivedUri.queryParameters['bd'].toString();
          return '/change_password';
        }
      } else {
        if (isAppInit == false) {
          isAppInit = true;
          return "/load_login";
        } else {
          return null;
        }
      }
    },
    //initialLocation: needsRedirect == false ? "/load_login" : "/",
    routes: <GoRoute>[
      GoRoute(
        name: 'dummy_screen',
        path: '/',
        builder: (BuildContext context, GoRouterState state) => DummyScreen(),
      ),
      GoRoute(
        name: 'change_password',
        path: '/change_password',
        builder: (BuildContext context, GoRouterState state) =>
            ChangePassword(),
      ),
      GoRoute(
        name: 'email_validation',
        path: '/email_validation',
        builder: (BuildContext context, GoRouterState state) =>
            EmailValidation(),
      ),
      GoRoute(
        name: 'create_account',
        path: '/create_account',
        builder: (BuildContext context, GoRouterState state) =>
            CreateAccountScreen(),
      ),
      GoRoute(
        name: 'new_user_form',
        path: '/new_user_form',
        builder: (BuildContext context, GoRouterState state) => NewUserForm(),
      ),
      GoRoute(
        name: 'new_user_welcome',
        path: '/new_user_welcome',
        builder: (BuildContext context, GoRouterState state) =>
            NewUserWelcome(),
      ),
      GoRoute(
        name: 'load_login',
        path: '/load_login',
        builder: (BuildContext context, GoRouterState state) =>
            LoadLoginScreen(),
      ),
      GoRoute(
        name: 'login_signup',
        path: '/login_signup',
        builder: (BuildContext context, GoRouterState state) =>
            LoginSignupScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (BuildContext context, GoRouterState state) => HomeScreen(),
      ),
      GoRoute(
        name: 'user_detail',
        path: '/user_detail',
        builder: (BuildContext context, GoRouterState state) =>
            UserDetailScreen(),
      ),
    ],
  );
}

Future googleSignOut() async {
  bool? isLoggedGoogle = await GoogleSignInApi.isLoggedIn();
  if (isLoggedGoogle != null && isLoggedGoogle == true) {
    await GoogleSignInApi.logout();
  }
}
