import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/PageStatus.dart';

import '../Components/Modal/SFModalMessage.dart';

class StandardScreenViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;

  SFModalMessage modalMessage = SFModalMessage(
    title: "",
    onTap: () {},
    isHappy: true,
  );

  Widget? widgetForm;
  bool canTapBackground = true;

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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  void setWidgetForm(Widget widget) {
    widgetForm = widget;
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void setPageError(String message) {
    modalMessage = SFModalMessage(
        title: message, onTap: () => closeModal(), isHappy: false);
    pageStatus = PageStatus.ERROR;
    notifyListeners();
  }

  void setLoading() {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
  }
}
