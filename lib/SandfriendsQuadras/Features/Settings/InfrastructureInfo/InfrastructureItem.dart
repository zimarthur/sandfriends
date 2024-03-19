import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Model/Infrastructure.dart';
import '../../../../Common/Utils/Constants.dart';

class InfrastructureItem extends StatelessWidget {
  Function(bool) onTap;
  InfrastructureItem({
    super.key,
    required this.infrastructure,
    required this.onTap,
  });

  final Infrastructure infrastructure;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(!infrastructure.isSelected),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          color: secondaryPaper,
          border: Border.all(
            color: infrastructure.isSelected ? primaryBlue : divider,
            width: infrastructure.isSelected ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        margin: EdgeInsets.symmetric(vertical: defaultPadding / 2),
        child: Row(
          children: [
            SvgPicture.asset(
              infrastructure.iconPath,
              height: 25,
              width: 25,
              color: infrastructure.isSelected ? primaryBlue : textDarkGrey,
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Text(
              infrastructure.description,
              style: TextStyle(
                color: infrastructure.isSelected ? primaryBlue : textDarkGrey,
              ),
            ),
            Expanded(child: Container()),
            Checkbox(
              value: infrastructure.isSelected,
              activeColor: primaryBlue,
              onChanged: (selected) {
                if (selected != null) {
                  onTap(selected);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
