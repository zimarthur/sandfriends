import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../SF_Button.dart';
import '../../providers/match_provider.dart';

var today = DateUtils.dateOnly(DateTime.now());

String ConvertDatetime(DateTime dateTime) {
  return dateTime.toString().replaceAll('00:00:00.000', '');
}

class SFModalDatePicker extends StatefulWidget {
  List<DateTime?> datePickerRange = [];
  String dateText;
  StreamController<String> stream;

  SFModalDatePicker({
    required this.datePickerRange,
    required this.dateText,
    required this.stream,
  });
  @override
  State<SFModalDatePicker> createState() => _SFModalDatePickerState();
}

class _SFModalDatePickerState extends State<SFModalDatePicker> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              weekdayLabels: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'],
              firstDate: DateTime(today.year, today.month, today.day),
              calendarType: CalendarDatePicker2Type.range,
              selectedDayHighlightColor: AppTheme.colors.primaryBlue,
              weekdayLabelTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              controlsTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            initialValue: widget.datePickerRange,
            onValueChanged: (values) =>
                setState(() => widget.datePickerRange = values),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: width * 0.15, left: width * 0.15, bottom: height * 0.03),
          child: SFButton(
            iconPath: r"assets\icon\search.svg",
            buttonLabel: "Aplicar Filtro",
            textPadding: EdgeInsets.symmetric(vertical: height * 0.005),
            buttonType: ButtonType.Secondary,
            onTap: () {
              if (widget.datePickerRange.isNotEmpty) {
                var a = 1;
                var b = 2;
                var startDate = ConvertDatetime(widget.datePickerRange[0]!);
                var endDate = widget.datePickerRange.length > 1
                    ? ConvertDatetime(widget.datePickerRange[1]!)
                    : 'null';

                if (widget.datePickerRange.length > 1) {
                  widget.dateText =
                      "${widget.datePickerRange[0]!.day.toString().padLeft(2, '0')}/${widget.datePickerRange[0]!.month.toString().padLeft(2, '0')} - ${widget.datePickerRange[1]!.day.toString().padLeft(2, '0')}/${widget.datePickerRange[1]!.month.toString().padLeft(2, '0')}";
                } else {
                  widget.dateText =
                      "${widget.datePickerRange[0]!.day.toString().padLeft(2, '0')}/${widget.datePickerRange[0]!.month.toString().padLeft(2, '0')}";
                }
                widget.stream.add(endDate + "splitter" + startDate);
              }
            },
          ),
        )
      ],
    );
  }
}
