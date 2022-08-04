import 'package:flutter/material.dart';

class Redirect with ChangeNotifier {
  Uri? _redirect;
  Uri? get redirect => _redirect;
  set redirect(Uri? newUri) {
    _redirect = newUri;
    notifyListeners();
  }

  bool? _redirectBusy;
  bool? get redirectBusy => _redirectBusy;
  set redirectBusy(bool? status) {
    _redirectBusy = status;
    notifyListeners();
  }
}
