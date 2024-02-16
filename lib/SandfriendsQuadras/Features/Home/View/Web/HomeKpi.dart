import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Utils/Constants.dart';

class HomeKpi extends StatelessWidget {
  String iconPath;
  Color iconColor;
  Color backgroundColor;
  String title;
  int value;
  int lastValue;
  bool isCurrency;
  HomeKpi({
    required this.iconPath,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.value,
    required this.lastValue,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding / 2,
        horizontal: defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(
              defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
              color: backgroundColor,
            ),
            child: SvgPicture.asset(
              iconPath,
              color: iconColor,
              height: 20,
              width: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child: Text(
              title,
              style: TextStyle(color: textDarkGrey, fontSize: 10),
              maxLines: 1,
            ),
          ),
          Row(
            children: [
              if (isCurrency)
                Text(
                  "R\$",
                  style: TextStyle(
                    fontSize: 22,
                    color: textDarkGrey,
                  ),
                ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
