import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFDateTime.dart';

class DayFilter extends StatelessWidget {
  DateTime? date;
  int? weekDay;
  VoidCallback onYesterday;
  VoidCallback onTomorrow;
  Color themeColor;
  VoidCallback onOpenDateModal;
  DayFilter({
    required this.date,
    required this.weekDay,
    required this.onYesterday,
    required this.onTomorrow,
    required this.themeColor,
    required this.onOpenDateModal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        border: Border.all(color: divider),
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(2, 3),
            color: divider,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding / 4,
        horizontal: defaultPadding / 2,
      ),
      child: Row(children: [
        InkWell(
          onTap: () => onYesterday(),
          child: SvgPicture.asset(
            r"assets/icon/chevron_left.svg",
            color: textDarkGrey,
            height: 25,
          ),
        ),
        Expanded(
          child: date != null
              ? InkWell(
                  onTap: () => onOpenDateModal(),
                  child: Column(
                    children: [
                      Text(
                        weekday[getSFWeekday(date!.weekday)],
                        style: TextStyle(
                          color: textDarkGrey,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(date!),
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    weekday[weekDay!],
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        InkWell(
          onTap: () => onTomorrow(),
          child: SvgPicture.asset(
            r"assets/icon/chevron_right.svg",
            color: textDarkGrey,
            height: 25,
          ),
        ),
      ]),
    );
  }
}
