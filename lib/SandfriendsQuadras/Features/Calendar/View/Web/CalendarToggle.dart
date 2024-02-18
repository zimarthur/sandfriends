import 'package:flutter/material.dart';

import '../../../../../Common/Utils/Constants.dart';
import '../../Model/PeriodType.dart';

class CalendarToggle extends StatefulWidget {
  List<PeriodType> labels = [PeriodType.Daily, PeriodType.Weekly];
  PeriodType selectedIndex;
  Function(PeriodType) onChanged;
  bool horizontal;

  CalendarToggle({
    required this.selectedIndex,
    required this.onChanged,
    required this.horizontal,
  });
  @override
  State<CalendarToggle> createState() => _CalendarToggleState();
}

class _CalendarToggleState extends State<CalendarToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: textDisabled,
      ),
      child: widget.horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int labelIndex = 0;
                    labelIndex < widget.labels.length;
                    labelIndex++)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onChanged(widget.labels[labelIndex]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color:
                              widget.labels[labelIndex] == widget.selectedIndex
                                  ? primaryBlue
                                  : textDisabled,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.labels[labelIndex] == PeriodType.Weekly
                              ? "Semanal"
                              : "Diário",
                          style: TextStyle(
                              color: widget.labels[labelIndex] ==
                                      widget.selectedIndex
                                  ? textWhite
                                  : textDarkGrey),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int labelIndex = 0;
                    labelIndex < widget.labels.length;
                    labelIndex++)
                  InkWell(
                    onTap: () {
                      widget.onChanged(widget.labels[labelIndex]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: widget.labels[labelIndex] == widget.selectedIndex
                            ? primaryBlue
                            : textDisabled,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.labels[labelIndex] == PeriodType.Weekly
                            ? "Semanal"
                            : "Diário",
                        style: TextStyle(
                            color: widget.labels[labelIndex] ==
                                    widget.selectedIndex
                                ? textWhite
                                : textDarkGrey),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
