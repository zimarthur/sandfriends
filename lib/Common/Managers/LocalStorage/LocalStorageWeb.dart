import 'package:sandfriends/Common/Managers/LocalStorage/GenericLocalStorage.dart';
import 'dart:html';

class LocalStorage extends GenericLocalStorage {
  @override
  Future<dynamic> Function(String key) get getValue => (key) async {
        return window.localStorage[key];
      };

  @override
  Function(String key, dynamic value) get setValue => (key, value) {
        window.localStorage[key] = value;
      };
}
