import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';

class CourtDescription extends StatelessWidget {
  String description;
  Color themeColor;
  CourtDescription({
    required this.description,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.02),
          child: Text(
            "Sobre a quadra",
            style: TextStyle(color: themeColor, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.02),
          child: Text(
            description,
            style: TextStyle(color: textDarkGrey),
          ),
        ),
      ],
    );
  }
}
