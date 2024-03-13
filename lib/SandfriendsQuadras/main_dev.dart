import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Managers/WebStrategy/WebStrategyManager.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/SandfriendsQuadras/sandfriends_quadras_app.dart';

void main() {
  WebStrategyManager().initWebStrategy();
  runApp(
    SandfriendsQuadrasApp(
      flavor: Flavor.Dev,
    ),
  );
}
