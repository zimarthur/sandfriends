import 'package:sandfriends/Common/Managers/WebStrategy/WebStrategyWeb.dart'
    if (dart.library.io) 'package:sandfriends/Common/Managers/WebStrategy/WebStrategyMobile.dart';

class WebStrategyManager {
  final webStrat = WebStrategy();
  void initWebStrategy() {
    webStrat.setStrategy();
  }
}
