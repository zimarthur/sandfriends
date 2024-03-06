import 'package:flutter/material.dart';

import '../Components/Modal/SFModalMessage.dart';
import 'OverlayWidget.dart';

class StandardScreenViewModel extends ChangeNotifier {
  bool isLoading = false;

  bool canTapBackground = true;

  List<OverlayWidget> overlays = [];
  void addOverlayWidget(Widget widget, {bool showOnlyIfLast = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setPageStatusOk();
      overlays.add(
        OverlayWidget(
          widget: widget,
          showOnlyIfLast: showOnlyIfLast,
        ),
      );
      notifyListeners();
    });
  }

  void removeLastOverlay() {
    if (overlays.isNotEmpty) {
      overlays.removeLast();
      notifyListeners();
    }
  }

  void clearOverlays() {
    overlays.clear();
    notifyListeners();
  }

  void addModalMessage(SFModalMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setPageStatusOk();
      addOverlayWidget(
        SFModalMessage(
          title: message.title,
          description: message.description,
          onTap: () {
            if (message.onTap != null) {
              message.onTap!();
            }
            removeLastOverlay();
          },
          buttonIconPath: message.buttonIconPath,
          buttonText: message.buttonText,
          hideButton: message.hideButton,
          isHappy: message.isHappy,
        ),
      );
    });
  }

  void setPageStatusOk() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = false;
      notifyListeners();
    });
  }

  void setLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = true;
      notifyListeners();
    });
  }

  void closeModal() {
    setPageStatusOk();
    removeLastOverlay();
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
