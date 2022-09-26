import 'package:flutter/material.dart';
import 'package:sandfriends/models/enums.dart';

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

  int? _selectedPageIndex = 1;
  int? get selectedPageIndex => _selectedPageIndex;
  set selectedPageIndex(int? index) {
    _selectedPageIndex = index;
  }

  PageController pageController = PageController();
  void goto(int index) {
    pageController.jumpToPage(index);
  }

  EnumReturnPages? _originalPage;
  EnumReturnPages? get originalPage => _originalPage;
  set originalPage(EnumReturnPages? value) {
    _originalPage = value;
  }
}
