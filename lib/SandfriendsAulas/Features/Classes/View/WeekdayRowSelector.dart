import 'package:flutter/material.dart';

import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFDateTime.dart';

class WeekdayRowSelector extends StatelessWidget {
  int currentWeekday;
  Function(int) onSelectedWeekday;

  WeekdayRowSelector({
    required this.currentWeekday,
    required this.onSelectedWeekday,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      int weekdays = 7;
      double desiredButtonWidth = 40;
      double minSpaceBetween = defaultPadding / 4;
      double buttonWidth = 0;

      if (layoutConstraints.maxWidth <
          ((desiredButtonWidth * weekdays) +
              (minSpaceBetween * (weekdays + 1)))) {
        buttonWidth =
            (layoutConstraints.maxWidth - (minSpaceBetween * (weekdays + 1))) /
                weekdays;
      } else {
        buttonWidth = desiredButtonWidth;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int weekday = 0; weekday < 7; weekday++)
            GestureDetector(
              onTap: () => onSelectedWeekday(weekday),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                  border: Border.all(
                    color: currentWeekday == weekday ? primaryBlue : divider,
                  ),
                  color: currentWeekday == weekday
                      ? secondaryPaper
                      : divider.withAlpha(
                          125,
                        ),
                ),
                width: buttonWidth,
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding / 2,
                ),
                child: Text(
                  weekdayShort[weekday],
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        currentWeekday == weekday ? primaryBlue : textDarkGrey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}
