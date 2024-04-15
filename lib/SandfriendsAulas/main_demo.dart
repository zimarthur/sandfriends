import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/SandfriendsAulas/sandfriends_aulas_app.dart';

import '../Common/Managers/WebStrategy/WebStrategyManager.dart';

void main() {
  WebStrategyManager().initWebStrategy();
  runApp(
    SandfriendsAulasApp(
      flavor: Flavor.Demo,
    ),
  );
}
