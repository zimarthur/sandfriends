import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

enum Device { Android, Ios, Web }

Device get currentDevice {
  if (kIsWeb) {
    return Device.Web;
  } else if (Platform.isIOS) {
    return Device.Ios;
  } else if (Platform.isAndroid) {
    return Device.Android;
  }
  return Device.Web;
}
