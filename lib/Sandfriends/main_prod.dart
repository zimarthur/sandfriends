import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Sandfriends/sandfriends_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    SandfriendsApp(
      flavor: Flavor.Prod,
    ),
  );
}
