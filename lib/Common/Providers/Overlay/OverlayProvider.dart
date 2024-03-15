import 'package:flutter/material.dart';

class OverlayProvider extends ChangeNotifier {
  List<Widget> overlays = [];
  void addOverlayWidget(Widget widget) {
    overlays.add(widget);
    notifyListeners();
  }

  void removeLastOverlay() {
    overlays.removeLast();
    notifyListeners();
  }

  void clearOverlays() {
    overlays.clear();
    notifyListeners();
  }
}
