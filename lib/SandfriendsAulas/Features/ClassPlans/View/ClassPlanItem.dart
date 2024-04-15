import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';

import '../../../../Common/Utils/Constants.dart';

class ClassPlanItem extends StatelessWidget {
  ClassPlan classPlan;
  bool isSelected;
  VoidCallback onTap;
  VoidCallback onDelete;
  ClassPlanItem({
    required this.classPlan,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: defaultPadding,
      ),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            border: Border.all(
              color: isSelected ? primaryBlue : divider,
            ),
          ),
          padding: EdgeInsets.all(defaultPadding / 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      classPlan.format.title,
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  if (isSelected)
                    InkWell(
                        onTap: () => onDelete(),
                        child: SvgPicture.asset(
                          r"assets/icon/delete.svg",
                          color: red,
                          height: 25,
                        )),
                ],
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/clock.svg",
                    height: 20,
                    color: textDarkGrey,
                  ),
                  SizedBox(
                    width: defaultPadding / 4,
                  ),
                  Text(
                    classPlan.classFrequency.title,
                    style: TextStyle(
                      color: textDarkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding / 4,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/price.svg",
                    height: 20,
                    color: textDarkGrey,
                  ),
                  SizedBox(
                    width: defaultPadding / 4,
                  ),
                  Text(
                    classPlan.priceDetail,
                    style: TextStyle(
                      color: textDarkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
