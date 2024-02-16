import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/Model/CalendarType.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import '../../../../../../Utils/Constants.dart';
import 'package:intl/intl.dart';
import '../../../../../../Utils/SFDateTime.dart';
import 'HourWidget.dart';

class SFCalendarWeek extends StatefulWidget {
  CalendarViewModel viewModel;
  double height;
  double width;

  SFCalendarWeek({
    required this.viewModel,
    required this.height,
    required this.width,
  });

  @override
  State<SFCalendarWeek> createState() => _SFCalendarWeekState();
}

class _SFCalendarWeekState extends State<SFCalendarWeek> {
  ScrollController horizontalController = ScrollController(),
      verticalController = ScrollController(),
      headerController = ScrollController();

  int hoveredHour = -1;
  DateTime? hoveredDay;

  @override
  void initState() {
    super.initState();

    horizontalController.addListener(() {
      headerController.jumpTo(horizontalController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    double tableHeight = widget.height * 0.95;
    double tableWidth = widget.width;
    double tableLineHeight =
        tableHeight * 0.036 < 30 ? 30 : tableHeight * 0.036;
    double tableColumnSpacing = tableWidth * 0.01;
    double tableColumnWidth = tableWidth * 0.105 < 70 ? 70 : tableWidth * 0.105;
    double tableHeaderHeight = tableLineHeight * 1.5;

    return SizedBox(
      width: tableWidth,
      height: tableHeight,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: tableColumnWidth,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: headerController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var day in widget.viewModel.selectedWeek)
                        Container(
                          width: tableColumnWidth,
                          margin: EdgeInsets.symmetric(
                              horizontal: tableColumnSpacing),
                          child: Container(
                            height: tableHeaderHeight,
                            alignment: Alignment.center,
                            width: tableColumnWidth,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              border: Border.all(color: primaryBlue, width: 2),
                            ),
                            child: Text(
                              widget.viewModel.calendarType ==
                                      CalendarType.Match
                                  ? "${weekdayShort[getSFWeekday(day.weekday)]}\n${DateFormat('dd/MM').format(day)}"
                                  : weekdayRecurrent[getSFWeekday(day.weekday)],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: textWhite),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              controller: verticalController,
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var hour in widget.viewModel.minMaxHourRangeWeek)
                        Container(
                          alignment: Alignment.center,
                          height: tableLineHeight,
                          child: Container(
                            width: tableColumnWidth * 0.7,
                            height: tableLineHeight * 0.7,
                            margin: EdgeInsets.symmetric(
                                horizontal: tableColumnWidth * 0.15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: hoveredHour == hour.hour
                                    ? primaryBlue.withOpacity(0.3)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              hour.hourString,
                              style: TextStyle(
                                  color: hoveredHour == hour.hour
                                      ? primaryDarkBlue
                                      : textDarkGrey),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var day in widget.viewModel.selectedWeekMatches)
                            Container(
                              width: tableColumnWidth,
                              margin: EdgeInsets.symmetric(
                                  horizontal: tableColumnSpacing),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right:
                                      BorderSide(color: primaryBlue, width: 2),
                                  left:
                                      BorderSide(color: primaryBlue, width: 2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (var hour in day.dayMatches)
                                    Padding(
                                      padding: hour.startingHour.hour ==
                                              day.dayMatches.first.startingHour
                                                  .hour
                                          ? const EdgeInsets.only(top: 5)
                                          : hour.startingHour.hour ==
                                                  day.dayMatches.last
                                                      .startingHour.hour
                                              ? const EdgeInsets.only(bottom: 5)
                                              : const EdgeInsets.all(0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: tableLineHeight,
                                        child: widget.viewModel.calendarType ==
                                                CalendarType.Match
                                            ? HourWidget(
                                                isHovered: day.date ==
                                                        hoveredDay &&
                                                    hour.startingHour.hour ==
                                                        hoveredHour,
                                                isOperationHour:
                                                    hour.operationHour,
                                                isExpired: isHourPast(day.date,
                                                    hour.startingHour),
                                                startingHour: hour.startingHour,
                                                calendarType: widget
                                                    .viewModel.calendarType,
                                                matchesLength: hour
                                                    .matchesLengthConsideringRecurrent(),
                                                //essa ultima parte do calculo é para um mensalista em um mês que a partida ainda,
                                                date: day.date,
                                                height: tableLineHeight,
                                                width: tableColumnWidth,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == false) {
                                                      hoveredHour = -1;
                                                      hoveredDay = null;
                                                    } else {
                                                      hoveredHour = hour
                                                          .startingHour.hour;
                                                      hoveredDay = day.date;
                                                    }
                                                  });
                                                },
                                                onTap: () => widget.viewModel
                                                    .setCourtsAvailabilityWidget(
                                                  context,
                                                  day.date,
                                                  hour.startingHour,
                                                  hour.matches ?? [],
                                                  hour.recurrentMatches ?? [],
                                                ),
                                              )
                                            : HourWidget(
                                                isHovered: day.date ==
                                                        hoveredDay &&
                                                    hour.startingHour.hour ==
                                                        hoveredHour,
                                                isOperationHour:
                                                    hour.operationHour,
                                                isExpired: false,
                                                calendarType: widget
                                                    .viewModel.calendarType,
                                                startingHour: hour.startingHour,
                                                matchesLength: hour
                                                    .recurrentMatches!.length,
                                                date: day.date,
                                                height: tableLineHeight,
                                                width: tableColumnWidth,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == false) {
                                                      hoveredHour = -1;
                                                      hoveredDay = null;
                                                    } else {
                                                      hoveredHour = hour
                                                          .startingHour.hour;
                                                      hoveredDay = day.date;
                                                    }
                                                  });
                                                },
                                                onTap: () => widget.viewModel
                                                    .setRecurrentCourtsAvailabilityWidget(
                                                  context,
                                                  day.date,
                                                  hour,
                                                ),
                                              ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: tableColumnWidth,
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: headerController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var day in widget.viewModel.selectedWeek)
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 16,
                              width: tableColumnWidth,
                              margin: EdgeInsets.symmetric(
                                  horizontal: tableColumnSpacing),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: primaryBlue, width: 2),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                              ),
                            ),
                            Container(
                              height: 4,
                              width: tableColumnWidth - 4,
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.symmetric(
                                  horizontal: tableColumnSpacing),
                              color: secondaryPaper,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
