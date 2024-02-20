import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import '../Utils/Responsive.dart';
import 'DatePicker.dart';
import 'SFButton.dart';

class DatePickerModal extends StatefulWidget {
  Function(DateTime, DateTime?) onDateSelected;
  VoidCallback onReturn;
  bool allowFutureDates;
  bool allowPastDates;
  String? title;
  String? actionButtonTitle;
  DatePickerModal({
    required this.onDateSelected,
    required this.onReturn,
    this.allowFutureDates = true,
    this.allowPastDates = true,
    this.title,
    this.actionButtonTitle,
  });

  @override
  State<DatePickerModal> createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  DateTime? startDate;
  DateTime? endDate;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context)
          ? defaultPadding / 2
          : 2 * defaultPadding),
      width: Responsive.isMobile(context) ? width * 0.9 : 400,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title ?? "Busca Personalizada",
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                startDate == null
                    ? "-"
                    : DateFormat("dd/MM").format(startDate!),
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 18,
                ),
              ),
              if (endDate != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Text("-"),
                ),
                Text(
                  DateFormat("dd/MM").format(endDate!),
                  style: TextStyle(
                    color: textDarkGrey,
                    fontSize: 18,
                  ),
                )
              ]
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          DatePicker(
            allowPastDates: widget.allowPastDates,
            multiDate: true,
            initialDates: [startDate, endDate],
            onMultiDateSelected: (dates) {
              setState(() {
                startDate = dates.first!;
                if (dates.last != dates.first!) {
                  endDate = dates.last;
                } else {
                  endDate = null;
                }
              });
            },
            allowFutureDates: widget.allowFutureDates,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  isPrimary: false,
                  onTap: () => widget.onReturn(),
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: widget.actionButtonTitle ?? "Filtrar",
                  onTap: () {
                    if (startDate != null) {
                      widget.onDateSelected(startDate!, endDate);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
