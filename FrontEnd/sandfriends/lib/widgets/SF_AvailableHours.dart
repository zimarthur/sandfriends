import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/match_provider.dart';

import '../models/court.dart';
import '../theme/app_theme.dart';

class SFAvailableHours extends StatefulWidget {
  final Court court;
  final int hourIndex;

  SFAvailableHours({
    required this.court,
    required this.hourIndex,
  });

  @override
  State<SFAvailableHours> createState() => _SFAvailableHoursState();
}

class _SFAvailableHoursState extends State<SFAvailableHours> {
  bool isSelectedHour(BuildContext context) {
    if ((Provider.of<MatchProvider>(context).indexSelectedCourt ==
            widget.court.index) &&
        (Provider.of<MatchProvider>(context).indexSelectedTime ==
            widget.hourIndex)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Provider.of<MatchProvider>(context, listen: false)
              .indexSelectedCourt = widget.court.index;
          Provider.of<MatchProvider>(context, listen: false).indexSelectedTime =
              widget.hourIndex;
          Provider.of<MatchProvider>(context, listen: false).selectedCourt =
              widget.court;
          Provider.of<MatchProvider>(context, listen: false).selectedCourtTime =
              widget.court.availableHours[widget.hourIndex].hourIndex;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          width: 75,
          decoration: BoxDecoration(
            color: isSelectedHour(context)
                ? AppTheme.colors.primaryBlue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.colors.primaryBlue, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\clock.svg",
                      color: isSelectedHour(context)
                          ? AppTheme.colors.textWhite
                          : AppTheme.colors.textBlue,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.court.availableHours[widget.hourIndex].hour,
                          style: TextStyle(
                            color: isSelectedHour(context)
                                ? AppTheme.colors.textWhite
                                : AppTheme.colors.textBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      r"assets\icon\payment.svg",
                      color: isSelectedHour(context)
                          ? AppTheme.colors.textWhite
                          : AppTheme.colors.textBlue,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${widget.court.availableHours[widget.hourIndex].getCheapestCourt().toString()}/h",
                          style: TextStyle(
                            color: isSelectedHour(context)
                                ? AppTheme.colors.textWhite
                                : AppTheme.colors.textBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
