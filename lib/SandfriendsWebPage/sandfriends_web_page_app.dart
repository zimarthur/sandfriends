import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/generic_app.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageScreen.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Store/View/StoreScreen.dart';

class SandfriendsWebPageApp extends GenericApp {
  SandfriendsWebPageApp({
    required super.flavor,
  });

  @override
  String get appTitle => "Sandfriends";

  @override
  Product get product => Product.SandfriendsQuadras;

  @override
  Function(Uri link) get handleLink => (link) {};

  @override
  Function(Map<String, dynamic> data) get handleNotification => (data) {};

  @override
  Route? Function(RouteSettings p1)? get onGenerateRoute => (settings) {
        return null;
      };

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (BuildContext context) => StoreScreen(),
        '/lp': (BuildContext context) => LandingPageScreen(),
      };
}
