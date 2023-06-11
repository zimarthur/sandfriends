import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/Constants.dart';

class MatchSearchResultTitle extends StatelessWidget {
  String title;
  String iconPath;
  String description;
  Color themeColor;

  MatchSearchResultTitle({
    required this.title,
    required this.iconPath,
    required this.description,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          margin: EdgeInsets.only(top: height * 0.01),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                color: themeColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: SvgPicture.asset(r'assets\icon\divider.svg'),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          width: double.infinity,
          child: Text(
            description,
            textScaleFactor: 0.9,
            style: TextStyle(color: textDarkGrey),
          ),
        ),
      ],
    );
  }
}
