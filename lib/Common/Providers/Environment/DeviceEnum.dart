import 'dart:io';

enum Device { Android, Ios, Web }

Device get currentDevice {
  if (Platform.isIOS) {
    return Device.Ios;
  } else if (Platform.isAndroid) {
    return Device.Android;
  }
  return Device.Web;
}
