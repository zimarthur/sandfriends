import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import '../Common/Managers/WebStrategy/WebStrategyManager.dart';
import 'sandfriends_web_page_app.dart';

void main() {
  WebStrategyManager().initWebStrategy();
  runApp(
    SandfriendsWebPageApp(
      flavor: Flavor.Prod,
    ),
  );
}
