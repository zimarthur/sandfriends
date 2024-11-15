import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Utils/Constants.dart';

class UserCardHomeItem extends StatelessWidget {
  final String text;
  final String iconPath;
  const UserCardHomeItem({
    Key? key,
    required this.text,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          color: secondaryPaper,
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              text,
              style: const TextStyle(
                color: textWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
