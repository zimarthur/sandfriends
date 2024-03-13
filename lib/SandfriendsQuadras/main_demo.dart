import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/SandfriendsQuadras/sandfriends_quadras_app.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  runApp(
    SandfriendsQuadrasApp(
      flavor: Flavor.Demo,
    ),
  );
}
