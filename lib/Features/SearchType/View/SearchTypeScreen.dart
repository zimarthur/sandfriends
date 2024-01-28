import 'package:flutter/material.dart';
import 'package:sandfriends/Features/SearchType/View/SearchTypeWidget.dart';
import 'package:sandfriends/Utils/PageStatus.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';

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
    return SFStandardScreen(
        pageStatus: PageStatus.OK,
        enableToolbar: false,
        messageModalWidget: null,
        onTapBackground: () {},
        onTapReturn: () => Navigator.pop(context),
        child: SearchTypeWidget(
          showReturnArrow: showReturnArrow,
          isRecurrent: isRecurrent,
        ));
  }
}
