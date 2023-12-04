import 'package:flutter/material.dart';

class SFTabItem {
  String name;
  Widget displayWidget;
  Function(SFTabItem) onTap;

  SFTabItem({
    required this.name,
    required this.displayWidget,
    required this.onTap,
  });
}
