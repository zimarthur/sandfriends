import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class SFCard extends StatelessWidget {
  double height;
  double width;
  String title;
  Widget child;

  SFCard(
      {super.key,
      required this.height,
      required this.width,
      required this.title,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: divider, width: 2),
        color: secondaryPaper,
      ),
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryBack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(
                  defaultBorderRadius,
                ),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: textDarkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width,
            height: 2,
            color: divider,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
