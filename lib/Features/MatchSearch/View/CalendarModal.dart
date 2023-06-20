import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';

class CalendarModal extends StatefulWidget {
  List<DateTime?> dateRange;
  Function(List<DateTime?>) onSubmit;

  CalendarModal({Key? key, 
    required this.dateRange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  var today = DateUtils.dateOnly(DateTime.now());
  late List<DateTime?> modalDateTimes;

  @override
  void initState() {
    modalDateTimes = widget.dateRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                weekdayLabels: [
                  'Dom',
                  'Seg',
                  'Ter',
                  'Qua',
                  'Qui',
                  'Sex',
                  'Sáb'
                ],
                firstDate: DateTime(today.year, today.month, today.day),
                calendarType: CalendarDatePicker2Type.range,
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
              ),
              initialValue: modalDateTimes,
              onValueChanged: (values) {
                modalDateTimes = values;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: width * 0.15, left: width * 0.15, bottom: height * 0.03),
            child: SFButton(
              iconPath: r"assets\icon\search.svg",
              buttonLabel: "Aplicar Filtro",
              textPadding: EdgeInsets.symmetric(vertical: height * 0.005),
              isPrimary: false,
              onTap: () => widget.onSubmit(modalDateTimes),
            ),
          )
        ],
      ),
    );
  }
}
