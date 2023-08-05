import 'package:flutter/material.dart';
import 'package:sandfriends/Remote/Url.dart';

class EnvironmentProvider extends ChangeNotifier {
  Environment currentEnvironment = Environment.Prod;
  setEnvironment(String rawEnvironment) {
    if (rawEnvironment == "prod") {
      currentEnvironment = Environment.Prod;
    } else {
      currentEnvironment = Environment.Debug;
    }
    notifyListeners();
  }

  String urlBuilder(String endPoint) {
    if (currentEnvironment == Environment.Prod) {
      return sandfriendsProd + endPoint;
    } else {
      return sandfriendsDebug + endPoint;
    }
  }
}

enum Environment { Prod, Debug }
