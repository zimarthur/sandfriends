import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SF_Button.dart';

class TimeModal extends StatefulWidget {
  TimeRangeResult? timeRange;
  Function(TimeRangeResult?) onSubmit;

  TimeModal({
    required this.timeRange,
    required this.onSubmit,
  });

  @override
  State<TimeModal> createState() => _TimeModalState();
}

class _TimeModalState extends State<TimeModal> {
  TimeRangeResult? modalTimeRange;

  @override
  void initState() {
    modalTimeRange = widget.timeRange;
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
        boxShadow: [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Que horas você quer jogar?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryBlue),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: width * 0.08)),
                SFButton(
                  textPadding: EdgeInsets.all(width * 0.02),
                  buttonLabel: "Limpar",
                  onTap: () => widget.onSubmit(
                    TimeRangeResult(
                      TimeOfDay(hour: 1, minute: 0),
                      TimeOfDay(
                        hour: 23,
                        minute: 00,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            child: TimeRange(
              fromTitle: const Text(
                'De',
              ),
              toTitle: const Text(
                'Até',
              ),
              titlePadding: 20,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black87),
              activeTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
              borderColor: primaryBlue,
              backgroundColor: Colors.transparent,
              activeBackgroundColor: primaryBlue,
              initialRange: modalTimeRange,
              firstTime: const TimeOfDay(hour: 1, minute: 0),
              lastTime: const TimeOfDay(hour: 23, minute: 00),
              timeStep: 60,
              timeBlock: 60,
              onRangeCompleted: (range) => modalTimeRange = range,
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
              onTap: () => widget.onSubmit(modalTimeRange),
            ),
          )
        ],
      ),
    );
  }
}
