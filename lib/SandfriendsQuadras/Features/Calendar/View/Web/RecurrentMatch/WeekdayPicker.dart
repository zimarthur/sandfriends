import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';

import '../../../../../Utils/Constants.dart';
import '../../../../../Utils/SFDateTime.dart';

class WeekdayPicker extends StatefulWidget {
  Function(int) onChanged;
  int selectedIndex;

  WeekdayPicker({
    required this.onChanged,
    required this.selectedIndex,
  });

  @override
  State<WeekdayPicker> createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          for (var day in weekdayRecurrent)
            Row(
              children: [
                Radio(
                  value: day,
                  activeColor: primaryBlue,
                  groupValue: weekdayRecurrent[widget.selectedIndex],
                  onChanged: (newValue) => setState(() {
                    widget.onChanged(weekdayRecurrent.indexOf(day));
                  }),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  day,
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
