import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageKeysEnum.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageWeb.dart'
    if (dart.library.io) 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageMobile.dart';

class LocalStorageManager {
  final localStorage = LocalStorage();
  Map<LocalStorageKeys, String> keys = {
    LocalStorageKeys.AccessToken: "AccessToken",
    LocalStorageKeys.LastPage: "LastPage",
    LocalStorageKeys.LastNotificationId: "LastNotificationId",
  };

  void storeAccessToken(BuildContext context, String accessToken) {
    localStorage.setValue(
        buildKey(context, keys[LocalStorageKeys.AccessToken]!), accessToken);
  }

  Future<String?> getAccessToken(BuildContext context) async {
    return localStorage.getValue(
      buildKey(
        context,
        keys[LocalStorageKeys.AccessToken]!,
      ),
    ) as Future<String?>;
  }

  void storeLastPage(BuildContext context, String pageName) {
    localStorage.setValue(
        buildKey(context, keys[LocalStorageKeys.LastPage]!), pageName);
  }

  Future<String?> getLastPage(BuildContext context) async {
    return localStorage.getValue(
      buildKey(
        context,
        keys[LocalStorageKeys.LastPage]!,
      ),
    ) as Future<String?>;
  }

  void storeLastNotificationId(BuildContext context, int lastNotificationId) {
    localStorage.setValue(
        buildKey(context, keys[LocalStorageKeys.LastNotificationId]!),
        lastNotificationId.toString());
  }

  Future<int?> getLastNotificationId(BuildContext context) async {
    String? lastNotificationId = await localStorage.getValue(
      buildKey(
        context,
        keys[LocalStorageKeys.LastNotificationId]!,
      ),
    );
    return lastNotificationId != null ? int.parse(lastNotificationId) : null;
  }

  String buildKey(BuildContext context, String key) {
    final environment =
        Provider.of<EnvironmentProvider>(context, listen: false).environment;
    return "${environment.flavor.flavorString}${environment.product.productString}$key";
  }
}
