import 'package:flutter/material.dart';
import 'package:sandfriends/Sandfriends/Features/SearchType/View/SearchTypeWidget.dart';

class SearchTypeScreen extends StatelessWidget {
  bool isRecurrent;
  bool showReturnArrow;
  SearchTypeScreen({
    required this.isRecurrent,
    this.showReturnArrow = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchTypeWidget(
      showReturnArrow: showReturnArrow,
      isRecurrent: isRecurrent,
    );
  }
}
