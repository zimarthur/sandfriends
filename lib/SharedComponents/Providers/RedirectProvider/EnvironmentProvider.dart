import 'package:flutter/material.dart';
import 'package:sandfriends/Remote/Url.dart';

class EnvironmentProvider extends ChangeNotifier {
  Environment currentEnvironment = Environment.Prod;
  setEnvironment(String rawEnvironment) {
    if (rawEnvironment == "prod") {
      currentEnvironment = Environment.Prod;
    } else if (rawEnvironment == "dev") {
      currentEnvironment = Environment.Dev;
    } else {
      currentEnvironment = Environment.Demo;
    }
    notifyListeners();
  }

  String urlBuilder(String endPoint) {
    if (currentEnvironment == Environment.Prod) {
      return sandfriendsProd + endPoint;
    } else if (currentEnvironment == Environment.Dev) {
      return sandfriendsDev + endPoint;
    } else {
      return sandfriendsDemo + endPoint;
    }
  }
}

enum Environment { Prod, Dev, Demo }
