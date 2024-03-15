import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/actions.dart';
import 'package:sandfriends/Common/Managers/WebStrategy/GenericWebStrategy.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WebStrategy extends GenericWebStrategy {
  @override
  VoidCallback get setStrategy => () {
        setUrlStrategy(PathUrlStrategy());
      };
}
