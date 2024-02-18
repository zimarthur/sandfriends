import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/DatePicker.dart';

import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/Utils/Constants.dart';

class CalendarModal extends StatefulWidget {
  final List<DateTime?> dateRange;
  final bool allowMultiDates;
  final Function(List<DateTime?>) onSubmit;

  const CalendarModal({
    Key? key,
    required this.allowMultiDates,
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
            child: DatePicker(
              allowPastDates: false,
              multiDate: true,
              initialDates: modalDateTimes,
              onMultiDateSelected: (dates) {
                setState(() {
                  modalDateTimes = dates;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: width * 0.15, left: width * 0.15, bottom: height * 0.03),
            child: SFButton(
              buttonLabel: "Salvar",
              textPadding: EdgeInsets.symmetric(vertical: height * 0.005),
              onTap: () => widget.onSubmit(modalDateTimes),
            ),
          )
        ],
      ),
    );
  }
}