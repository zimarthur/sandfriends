import 'package:flutter/material.dart';

import '../../../../Utils/Constants.dart';

class CourtDescription extends StatelessWidget {
  final String description;
  final Color themeColor;
  const CourtDescription({
    Key? key,
    required this.description,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sobre a quadra",
          style: TextStyle(
            color: themeColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          description,
          style: const TextStyle(color: textDarkGrey),
        ),
      ],
    );
  }
}
