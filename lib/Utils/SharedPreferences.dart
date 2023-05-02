import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String accessTokenKey = "AccessToken";

Future<String?> getAccessToken() async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: accessTokenKey);
}

Future setAccessToken(String accessToken) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: accessTokenKey, value: accessToken);
}
