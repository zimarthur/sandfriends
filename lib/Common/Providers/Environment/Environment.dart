import 'package:sandfriends/Common/Providers/Environment/DeviceEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';

class Environment {
  Product product;
  Flavor flavor;
  Device device;
  Environment({
    required this.product,
    required this.flavor,
    required this.device,
  });
}
