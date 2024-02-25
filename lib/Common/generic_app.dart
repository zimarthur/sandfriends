import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/Managers/Firebase/FirebaseManager.dart';
import 'package:sandfriends/Common/Managers/LocalNotifications/LocalNotificationsManager.dart';
import 'package:sandfriends/Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/ViewModel/DataProvider.dart';
import '../Sandfriends/Providers/RedirectProvider/RedirectProvider.dart';
import '../SandfriendsQuadras/Features/Menu/ViewModel/MenuProvider.dart';
import 'Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class GenericApp extends StatefulWidget {
  final Flavor flavor;
  GenericApp({
    Key? key,
    required this.flavor,
  }) : super(key: key);

  Product get product;
  Function(Uri) get handleLink;
  Function(Map<String, dynamic>) get handleNotification;
  Route<dynamic>? Function(RouteSettings)? get onGenerateRoute;
  Map<String, Widget Function(BuildContext)> get routes;
  String get appTitle;
  String? initialRoute;

  @override
  State<GenericApp> createState() => _AppState();
}

class _AppState extends State<GenericApp> {
  bool _initialURILinkHandled = false;

  StreamSubscription? _streamSubscription;

  late EnvironmentProvider environmentProvider;

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        setState(() {
          if (uri != null) {
            widget.handleLink(uri);
          }
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
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

          widget.handleLink(initialURI);
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
      }
    }
  }

  @override
  void initState() {
    environmentProvider = EnvironmentProvider(
      widget.product,
      widget.flavor,
    );
    _initURIHandler();
    _incomingLinkHandler();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseManager(
        environment: environmentProvider.environment,
      ).initialize(
        messagingCallback: widget.handleNotification,
      );
      await LocalNotificationsManager().initialize(widget.handleNotification);
    });
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
      providers: widget.product == Product.Sandfriends
          ? [
              ChangeNotifierProvider(
                create: (_) => environmentProvider,
              ),
              ChangeNotifierProvider(
                create: (_) => CategoriesProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => RedirectProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CategoriesProvider(),
              ),
            ]
          : [
              ChangeNotifierProvider(
                create: (_) => environmentProvider,
              ),
              ChangeNotifierProvider(
                create: (_) => MenuProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => DataProvider(),
              ),
            ],
      child: MaterialApp(
        title: widget.appTitle,
        debugShowCheckedModeBanner: false,
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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        theme: ThemeData(
            scaffoldBackgroundColor: secondaryBack,
            fontFamily: "Lexend",
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        navigatorKey: navigatorKey,
        onGenerateRoute: widget.onGenerateRoute,
        routes: widget.routes,
        initialRoute: widget.initialRoute,
      ),
    );
  }
}
