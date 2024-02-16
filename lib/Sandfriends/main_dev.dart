import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Sandfriends/sandfriends_app.dart';

void main() async {
  runApp(
    SandfriendsApp(
      flavor: Flavor.Dev,
    ),
  );
}
