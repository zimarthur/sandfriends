import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';

import '../../../Utils/Constants.dart';
import '../SFButton.dart';

class TimeModal extends StatefulWidget {
  final TimeRangeResult? timeRange;
  final Function(TimeRangeResult?) onSubmit;
  final Color themeColor;

  const TimeModal({
    Key? key,
    required this.timeRange,
    required this.onSubmit,
    this.themeColor = primaryBlue,
  }) : super(key: key);

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
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
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
                  child: Text(
                    "Que horas você tem disponibilidade?",
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: widget.themeColor),
                  ),
                ),
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
              borderColor: widget.themeColor,
              backgroundColor: Colors.transparent,
              activeBackgroundColor: widget.themeColor,
              initialRange: modalTimeRange ??
                  TimeRangeResult(const TimeOfDay(hour: 6, minute: 0),
                      const TimeOfDay(hour: 23, minute: 00)),
              firstTime: const TimeOfDay(hour: 6, minute: 0),
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
              buttonLabel: "Salvar",
              color: widget.themeColor,
              textPadding: EdgeInsets.symmetric(vertical: height * 0.005),
              isPrimary: true,
              onTap: () => widget.onSubmit(modalTimeRange),
            ),
          )
        ],
      ),
    );
  }
}
