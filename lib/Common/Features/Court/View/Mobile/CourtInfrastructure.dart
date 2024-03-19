import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/Infrastructure.dart';

import '../../../../Utils/Constants.dart';

class CourtInfrastructure extends StatelessWidget {
  List<Infrastructure> infrastructures;
  Color themeColor;
  CourtInfrastructure({
    Key? key,
    required this.infrastructures,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Infraestrutura",
          style: TextStyle(
            color: themeColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: infrastructures.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: SvgPicture.asset(
                        infrastructures[index].iconPath,
                        height: 20,
                        color: textDarkGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Expanded(
                    child: Text(
                      infrastructures[index].description,
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
