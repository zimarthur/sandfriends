import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'sandfriends_web_page_app.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(
    SandfriendsWebPageApp(
      flavor: Flavor.Dev,
    ),
  );
}
