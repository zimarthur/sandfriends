import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/match_provider.dart';

import '../models/court_available_hours.dart';
import '../models/store_day.dart';
import '../theme/app_theme.dart';

class SFAvailableHours extends StatefulWidget {
  List<CourtAvailableHours> availableHours;
  final int widgetIndexTime;
  final int widgetIndexStore;
  final bool multipleSelection;

  SFAvailableHours({
    required this.availableHours,
    required this.widgetIndexTime,
    required this.widgetIndexStore,
    required this.multipleSelection,
  });

  @override
  State<SFAvailableHours> createState() => _SFAvailableHoursState();
}

class _SFAvailableHoursState extends State<SFAvailableHours> {
  bool isSelectedHour(BuildContext context) {
    if ((Provider.of<MatchProvider>(context).indexSelectedCourt ==
            widget.widgetIndexStore) &&
        (Provider.of<MatchProvider>(context)
            .indexSelectedTime
            .contains(widget.widgetIndexTime))) {
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
              .indexSelectedCourt = widget.widgetIndexStore;
          Provider.of<MatchProvider>(context, listen: false)
              .indexSelectedTime
              .clear();
          Provider.of<MatchProvider>(context, listen: false)
              .selectedTime
              .clear();
          if (widget.multipleSelection) {
            for (int i = 0; i < widget.widgetIndexTime + 1; i++) {
              Provider.of<MatchProvider>(context, listen: false)
                  .indexSelectedTime
                  .add(i);
              Provider.of<MatchProvider>(context, listen: false)
                  .selectedTime
                  .add(widget.availableHours[i]);
            }
          } else {
            Provider.of<MatchProvider>(context, listen: false)
                .indexSelectedTime
                .add(widget.widgetIndexTime);
            Provider.of<MatchProvider>(context, listen: false)
                .selectedTime
                .add(widget.availableHours[widget.widgetIndexTime]);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          width: 75,
          decoration: BoxDecoration(
            color: isSelectedHour(context)
                ? AppTheme.colors.primaryBlue
                : AppTheme.colors.secondaryPaper,
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
                          widget.availableHours[widget.widgetIndexTime].hour,
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
                          "${widget.availableHours[widget.widgetIndexTime].price}/h",
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
