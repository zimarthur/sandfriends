import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';

var today = DateUtils.dateOnly(DateTime.now());

class DatePicker extends StatefulWidget {
  Function(DateTime)? onDateSelected;
  Function(List<DateTime?>)? onMultiDateSelected;
  bool multiDate;
  bool allowFutureDates;
  bool allowPastDates;
  DatePicker({
    this.onDateSelected,
    this.onMultiDateSelected,
    this.multiDate = false,
    this.allowFutureDates = true,
    this.allowPastDates = true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<DateTime?> initialDates = [];

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        firstDayOfWeek: 1,
        weekdayLabels: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'],
        firstDate: widget.allowPastDates == false
            ? DateTime.now()
            : Provider.of<DataProvider>(context, listen: false)
                .store!
                .approvalDate,
        calendarType: widget.multiDate
            ? CalendarDatePicker2Type.range
            : CalendarDatePicker2Type.single,
        selectedDayHighlightColor: primaryBlue,
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        lastDate: widget.allowFutureDates ? null : DateTime.now(),
      ),
      initialValue: initialDates,
      onValueChanged: (values) {
        if (widget.multiDate) {
          widget.onMultiDateSelected!(values);
        } else if (values.first != null) {
          widget.onDateSelected!(values.first!);
        }
        setState(() {});
      },
    );
  }
}
