import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../SharedComponents/Model/Store.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];
  List<Store> get stores => _stores;
  void addStore(Store store) {
    bool isNewStore = true;
    for (int i = 0; i < _stores.length; i++) {
      if (_stores[i].idStore == store.idStore) {
        isNewStore = false;
        break;
      }
    }
    if (isNewStore) {
      _stores.add(store);
      notifyListeners();
    }
  }

  void clearStores() {
    _stores.clear();
    notifyListeners();
  }
}
