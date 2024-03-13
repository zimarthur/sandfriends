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

  bool get isIos => device == Device.Ios;
  bool get isAndroid => device == Device.Android;
  bool get isWeb => device == Device.Web;

  bool get isSandfriends => product == Product.Sandfriends;
  bool get isSandfriendsQuadras => product == Product.SandfriendsQuadras;
  bool get isSandfriendsWebApp => product == Product.SandfriendsWebPage;
}
