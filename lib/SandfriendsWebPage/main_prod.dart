import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'sandfriends_web_page_app.dart';

void main() {
  runApp(
    SandfriendsWebPageApp(
      flavor: Flavor.Prod,
    ),
  );
}
