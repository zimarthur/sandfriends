import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'sandfriends_aulas_app.dart';

void main() {
  runApp(
    SandfriendsAulasApp(
      flavor: Flavor.Prod,
    ),
  );
}
