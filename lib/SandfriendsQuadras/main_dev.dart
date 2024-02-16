import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/SandfriendsQuadras/sandfriends_quadras_app.dart';

void main() {
  runApp(
    SandfriendsQuadrasApp(
      flavor: Flavor.Dev,
    ),
  );
}
