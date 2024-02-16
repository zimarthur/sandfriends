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
import 'Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class GenericApp extends StatefulWidget {
  final Flavor flavor;
  const GenericApp({
    Key? key,
    required this.flavor,
  }) : super(key: key);

  Product get product;
  Function(Uri) get handleLink;
  Function(Map<String, dynamic>) get handleNotification;
  List<ChangeNotifier> get providers;
  Route<dynamic>? Function(RouteSettings)? get onGenerateRoute;
  Map<String, Widget Function(BuildContext)> get routes;
  String get appTitle;

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
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
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
      providers: [
        ChangeNotifierProvider(
          create: (_) => environmentProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(),
        ),
        for (int i = 0; i < widget.providers.length; i++)
          ChangeNotifierProvider(
            create: (_) => widget.providers[i],
          )
      ],
      child: MaterialApp(
        title: widget.appTitle,
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
      ),
    );
  }
}
