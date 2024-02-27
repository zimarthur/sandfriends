import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/SandfriendsWebPage/sandfriends_web_page_app.dart';

void main() {
  runApp(
    SandfriendsWebPageApp(
      flavor: Flavor.Demo,
    ),
  );
}
