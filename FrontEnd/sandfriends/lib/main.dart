import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/court_provider.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/screens/court_screen.dart';
import 'package:sandfriends/screens/login/load_login.dart';
import 'package:sandfriends/screens/match_search_screen.dart';
import 'package:sandfriends/screens/notification_screen.dart';
import 'package:sandfriends/screens/open_matches_screen.dart';
import 'package:sandfriends/screens/reward_screen.dart';
import 'package:sandfriends/screens/sport_selection_screen.dart';
import 'package:sandfriends/screens/user_match_screen.dart';
import './providers/redirect_provider.dart';
import './screens/login/change_password.dart';
import 'package:sandfriends/screens/login/email_validation.dart';
import 'package:uni_links/uni_links.dart';
import '../api/google_signin_api.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/gender.dart';
import 'models/rank.dart';
import 'models/side_preference.dart';
import 'models/sport.dart';
import 'screens/login/create_account.dart';
import 'screens/login/new_user_form.dart';
import 'screens/login/new_user_welcome.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/login_signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/user_detail_screen.dart';
import './theme/app_theme.dart';
import './providers/login_provider.dart';
import './providers/match_provider.dart';
import './providers/store_provider.dart';
import 'providers/categories_provider.dart';
import 'models/user.dart';
import 'screens/match_screen.dart';
import 'screens/reward_user_screen.dart';

final redirecter = Redirect();
final loginInfo = Login();
final match = MatchProvider();

final categoriesProvider = CategoriesProvider();
var userProvider = UserProvider();

bool needsRedirect = false;
bool? isAppInit;

bool _initialUriIsHandled = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
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
    InitializeAppData(context).then((value) {
      _handleIncomingLinks();
      _handleInitialUri();
    });
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
          create: ((context) => userProvider),
        ),
        ChangeNotifierProvider<MatchProvider>(
          create: ((context) => match),
        ),
        ChangeNotifierProvider<StoreProvider>(
          create: ((context) => StoreProvider()),
        ),
        ChangeNotifierProvider<CourtProvider>(
          create: ((context) => CourtProvider()),
        ),
        ChangeNotifierProvider<CategoriesProvider>(
          create: ((context) => categoriesProvider),
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
          return '/match_screen/${receivedUri.queryParameters['bd'].toString()}/home/initialPage/feed_screen';
        }
      } else {
        if (isAppInit == false) {
          isAppInit = true;
          return redirecter.routeRedirect;
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
        name: 'reward_user_screen',
        path: '/reward_user_screen',
        builder: (BuildContext context, GoRouterState state) =>
            RewardUserScreen(),
      ),
      GoRoute(
        name: 'reward_screen',
        path: '/reward_screen',
        builder: (BuildContext context, GoRouterState state) => RewardScreen(),
      ),
      GoRoute(
        name: 'open_matches_screen',
        path: '/open_matches_screen',
        builder: (BuildContext context, GoRouterState state) =>
            const OpenMatchesScreen(),
      ),
      GoRoute(
        name: 'notification_screen',
        path: '/notification_screen',
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationScreen(),
      ),
      GoRoute(
        name: 'user_match_screen',
        path: '/user_match_screen',
        builder: (BuildContext context, GoRouterState state) =>
            UserMatchScreen(),
      ),
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
        name: 'load_login',
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            LoadLoginScreen(),
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
            NewUserWelcome(),
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

  Future<void> InitializeAppData(BuildContext context) async {
    match.ResetProviderAtributes();
    var response = await http.get(
      Uri.parse('https://www.sandfriends.com.br/GetAppCategories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (mounted) {
      if (response.statusCode == 200) {
        userProvider.clearMatchList();
        categoriesProvider.clearCategories();
        Map<String, dynamic> responseBody = json.decode(response.body);

        final responseSports = responseBody['Sports'];
        final responseGenders = responseBody['Genders'];
        final responseRanks = responseBody['Ranks'];
        final responseSidePreferences = responseBody['SidePreferences'];

        for (int i = 0; i < responseSports.length; i++) {
          Map sportJson = responseSports[i];
          Sport newSport = Sport(
              idSport: sportJson['IdSport'],
              description: sportJson['Description'],
              photoUrl: sportJson['SportPhoto']);
          categoriesProvider.addSport(newSport);
        }
        for (int i = 0; i < responseGenders.length; i++) {
          Map genderJson = responseGenders[i];
          Gender newgender = Gender(
            idGender: genderJson['IdGenderCategory'],
            name: genderJson['GenderName'],
          );
          categoriesProvider.addGender(newgender);
        }
        for (int i = 0; i < responseSidePreferences.length; i++) {
          Map sidePreferenceJson = responseSidePreferences[i];
          SidePreference newSidePreference = SidePreference(
              idSidePreference: sidePreferenceJson['IdSidePreferenceCategory'],
              name: sidePreferenceJson['SidePreferenceName']);
          categoriesProvider.addSidePreference(newSidePreference);
        }
        for (int i = 0; i < responseRanks.length; i++) {
          Map rankJson = responseRanks[i];
          Rank newRank = Rank(
            idRankCategory: rankJson['IdRankCategory'],
            sport: Sport(
              idSport: rankJson['Sport']['IdSport'],
              description: rankJson['Sport']['Description'],
              photoUrl: rankJson['Sport']['SportPhoto'],
            ),
            rankSportLevel: rankJson['RankSportLevel'],
            name: rankJson['RankName'],
            color: rankJson['RankColor'],
          );
          categoriesProvider.addRank(newRank);
        }
      }
      const storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: "AccessToken");
      bool isNewUser = false;
      String newAccessToken;

      if (accessToken != null) {
        response = await http.post(
          Uri.parse('https://www.sandfriends.com.br/ValidateToken'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, Object>{
              'AccessToken': accessToken,
            },
          ),
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          final responseLogin = responseBody['UserLogin'];

          final newAccessToken = responseLogin['AccessToken'];
          await storage.write(key: "AccessToken", value: newAccessToken);

          if (responseLogin['EmailConfirmationDate'] == null) {
            redirecter.routeRedirect = '/login_signup';
          } else if (responseLogin['IsNewUser'] == true) {
            redirecter.routeRedirect = '/new_user_welcome';
          } else {
            final responseUser = responseBody['User'];
            final responseUserMatchCounter = responseBody['MatchCounter'];

            userProvider.user = userFromJson(responseUser);
            userProvider.userMatchCounterFromJson(
                responseUserMatchCounter, categoriesProvider);

            redirecter.routeRedirect = '/home/feed_screen';
          }
        } else {
          //o token não é valido
          redirecter.routeRedirect = '/login_signup';
        }
      } else {
        //não tem token
        redirecter.routeRedirect = '/login_signup';
      }
    } else {
      redirecter.routeRedirect = '/login_signup';
      print("Deu pau carregando categories");
    }
  }
}

Future googleSignOut() async {
  bool? isLoggedGoogle = await GoogleSignInApi.isLoggedIn();
  if (isLoggedGoogle != null && isLoggedGoogle == true) {
    await GoogleSignInApi.logout();
  }
}
