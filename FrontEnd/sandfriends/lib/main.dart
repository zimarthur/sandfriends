import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/court_provider.dart';
import 'package:sandfriends/providers/sport_provider.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/screens/court_screen.dart';
import 'package:sandfriends/screens/login/dummy.dart';
import 'package:sandfriends/screens/match_search_screen.dart';
import 'package:sandfriends/screens/sport_selection_screen.dart';
import './providers/redirect_provider.dart';
import './screens/login/change_password.dart';
import 'package:sandfriends/screens/login/email_validation.dart';
import 'package:uni_links/uni_links.dart';
import '../api/google_signin_api.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';

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
import './providers/match_provider.dart';
import './providers/store_provider.dart';
import './providers/sport_provider.dart';
import 'models/user.dart';
import 'screens/match_screen.dart';

final redirecter = Redirect();
final loginInfo = Login();
final match = MatchProvider();

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

  void _handleIncomingLinks() {
    if (!kIsWeb) {
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

  Future<void> _handleInitialUri() async {
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
        /*ChangeNotifierProvider<Redirect>.value(
          value: redirecter,
        ),*/
        ChangeNotifierProvider<Redirect>(
          create: ((context) => Redirect()),
        ),
        ChangeNotifierProvider<Login>.value(
          value: loginInfo,
        ),
        ChangeNotifierProvider<UserProvider>(
          create: ((context) => UserProvider()),
        ),
        ChangeNotifierProvider<MatchProvider>(
          create: ((context) => MatchProvider()),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: ((context) => StoreProvider()),
        ),
        ChangeNotifierProvider<CourtProvider>(
          create: ((context) => CourtProvider()),
        ),
        ChangeNotifierProvider<SportProvider>(
          create: ((context) => SportProvider()),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.define(),
        builder: ((context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            )),
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
        } else if (receivedUri.queryParameters['ct'] == "mtch") {
          return '/match_screen/${receivedUri.queryParameters['bd'].toString()}';
        }
      } else {
        if (isAppInit == false) {
          isAppInit = true;
          return "/load_login";
        } else {
          return null;
        }
      }
      return null;
    },
    routes: <GoRoute>[
      GoRoute(
          name: 'court_screen',
          path:
              '/court_screen/:viewOnly/:returnTo/:returnToParam/:returnToParamValue',
          builder: (BuildContext context, GoRouterState state) {
            final viewOnly = state.params['viewOnly'];
            final returnTo = state.params['returnTo'];
            final returnToParam = state.params['returnToParam'];
            final returnToParamValue = state.params['returnToParamValue'];
            return CourtScreen(
              param: viewOnly,
              returnTo: returnTo!,
              returnToParam: returnToParam == 'null' ? null : returnToParam,
              returnToParamValue:
                  returnToParamValue == 'null' ? null : returnToParamValue,
            );
          }),
      GoRoute(
          name: 'match_screen',
          path:
              '/match_screen/:matchUrl/:returnTo/:returnToParam/:returnToParamValue',
          builder: (BuildContext context, GoRouterState state) {
            final matchUrl = state.params['matchUrl'];
            final returnTo = state.params['returnTo'];
            final returnToParam = state.params['returnToParam'];
            final returnToParamValue = state.params['returnToParamValue'];
            return MatchScreen(
              matchUrl: int.parse(matchUrl!),
              returnTo: returnTo!,
              returnToParam: returnToParam == 'null' ? null : returnToParam,
              returnToParamValue:
                  returnToParamValue == 'null' ? null : returnToParamValue,
            );
          }),
      GoRoute(
        name: 'match_search_screen',
        path: '/match_search_screen',
        builder: (BuildContext context, GoRouterState state) =>
            const MatchSearchScreen(),
      ),
      GoRoute(
        name: 'sport_selection',
        path: '/sport_selection',
        builder: (BuildContext context, GoRouterState state) =>
            SportSelectionScreen(),
      ),
      GoRoute(
        name: 'dummy_screen',
        path: '/',
        builder: (BuildContext context, GoRouterState state) => DummyScreen(),
      ),
      GoRoute(
        name: 'change_password',
        path: '/change_password',
        builder: (BuildContext context, GoRouterState state) =>
            const ChangePassword(),
      ),
      GoRoute(
        name: 'email_validation',
        path: '/email_validation',
        builder: (BuildContext context, GoRouterState state) =>
            const EmailValidation(),
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
        builder: (BuildContext context, GoRouterState state) =>
            const NewUserForm(),
      ),
      GoRoute(
        name: 'new_user_welcome',
        path: '/new_user_welcome',
        builder: (BuildContext context, GoRouterState state) =>
            const NewUserWelcome(),
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
        path: '/home/:initialPage',
        builder: (BuildContext context, GoRouterState state) {
          final query = state.params['initialPage'];
          return HomeScreen(
            initialPage: query,
          );
        },
      ),
      GoRoute(
        name: 'user_detail',
        path: '/user_detail',
        builder: (BuildContext context, GoRouterState state) =>
            const UserDetailScreen(),
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
