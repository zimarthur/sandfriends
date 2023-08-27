import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';

String accessTokenKey = "AccessToken";
String accessTokenKeyDemo = "AccessTokenDemo";
String accessTokenKeyDev = "AccessTokenDev";

String getFlavorTokenKey(BuildContext context) {
  switch (Provider.of<EnvironmentProvider>(context, listen: false)
      .currentEnvironment) {
    case Environment.Prod:
      return accessTokenKey;
    case Environment.Dev:
      return accessTokenKeyDev;
    case Environment.Demo:
      return accessTokenKeyDemo;
  }
}

Future<String?> getAccessToken(BuildContext context) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: getFlavorTokenKey(context));
}

Future setAccessToken(BuildContext context, String accessToken) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: getFlavorTokenKey(context), value: accessToken);
}
