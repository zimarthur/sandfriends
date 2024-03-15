import 'package:flutter/material.dart';

class OverlayWidget {
  Widget widget;
  bool showOnlyIfLast;
  OverlayWidget({
    required this.widget,
    required this.showOnlyIfLast,
  });
}
