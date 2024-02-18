import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Providers/Environment/DeviceEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/Environment.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Remote/Url.dart';

class EnvironmentProvider extends ChangeNotifier {
  late Environment environment;
  EnvironmentProvider(Product product, Flavor flavor) {
    environment =
        Environment(product: product, flavor: flavor, device: currentDevice);
    notifyListeners();
  }

  String urlBuilder(String endPoint, {bool isImage = false}) {
    String addReq = "";
    // if (!isImage || environment.product == Product.Sandfriends) {
    //   addReq = "/req";
    // }
    return "https://${environment.flavor.flavorString}${environment.product.productUrl}.$sandfriendsUrl$addReq$endPoint";
  }
}
