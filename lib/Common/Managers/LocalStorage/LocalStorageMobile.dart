import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/GenericLocalStorage.dart';

class LocalStorage extends GenericLocalStorage {
  @override
  Future<dynamic> Function(String key) get getValue => (key) async {
        const storage = FlutterSecureStorage();
        return await storage.read(
          key: key,
        );
      };

  @override
  Function(String key, dynamic value) get setValue => (key, value) {
        const storage = FlutterSecureStorage();
        storage.write(key: key, value: value);
      };
}
