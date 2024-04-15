import 'package:flutter/material.dart';

import '../../Common/Utils/Constants.dart';

class SectionTitleText extends StatelessWidget {
  String title;
  SectionTitleText({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: textDarkGrey,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
