import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/Model/CalendarType.dart';
import 'package:sandfriends_web/Features/Calendar/View/Web/Calendar/Day/EmptyHourWidget.dart';
import 'package:sandfriends_web/Features/Calendar/View/Web/Calendar/Day/MatchHourWidget.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../../Utils/Constants.dart';

import '../../../../../../Utils/SFDateTime.dart';
import '../Week/HourWidget.dart';

class SFCalendarDay extends StatefulWidget {
  CalendarViewModel viewModel;
  double height;
  double width;

  SFCalendarDay({
    required this.height,
    required this.width,
    required this.viewModel,
  });

  @override
  State<SFCalendarDay> createState() => _SFCalendarDayState();
}

class _SFCalendarDayState extends State<SFCalendarDay> {
  ScrollController horizontalController = ScrollController(),
      verticalController = ScrollController(),
      headerController = ScrollController();

  int hoveredHour = -1;
  int hoveredCourt = -1;

  double hourHeight = 85;
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
    double tableColumnWidth = tableWidth * 0.105 < 70 ? 70 : tableWidth * 0.105;
    double tableHeaderHeight = tableLineHeight * 1.5;
    double tableDayWidth = (tableWidth - tableColumnWidth) * 0.95;
    double tableColumnDataWidth =
        tableDayWidth / widget.viewModel.courts.length < 300
            ? 300
            : tableDayWidth / widget.viewModel.courts.length;
    return SizedBox(
      width: tableWidth,
      height: tableHeight,
      child: Stack(
        children: [
          Container(
            width: tableDayWidth,
            height: tableHeight,
            margin: EdgeInsets.only(left: tableColumnWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryBlue, width: 2),
            ),
            child: Column(
              children: [
                Container(
                  height: tableHeaderHeight,
                  alignment: Alignment.center,
                  width: tableDayWidth,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(color: primaryBlue, width: 2),
                  ),
                  child: Text(
                    widget.viewModel.calendarDayTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textWhite),
                  ),
                ),
                if (widget.viewModel.selectedDayWorkingHours.isEmpty)
                  Expanded(
                      child: Center(
                    child: Text("Estabelecimento fechado neste dia"),
                  ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: tableHeaderHeight + 2, bottom: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: tableColumnWidth,
                    ),
                    Container(
                      width: tableDayWidth,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: headerController,
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: widget
                                  .viewModel.selectedDayWorkingHours.isNotEmpty
                              ? Row(
                                  children: [
                                    for (var court in widget.viewModel.courts)
                                      Container(
                                        width: tableColumnDataWidth,
                                        height: tableHeaderHeight,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: divider,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          court.description,
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(color: textBlue),
                                        ),
                                      ),
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.viewModel.selectedDayWorkingHours.isNotEmpty)
                  Flexible(
                    child: SingleChildScrollView(
                      controller: verticalController,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              for (var hour
                                  in widget.viewModel.selectedDayWorkingHours)
                                Container(
                                  alignment: Alignment.center,
                                  height: hourHeight,
                                  width: tableColumnWidth,
                                  child: Container(
                                    width: tableColumnWidth * 0.8,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                        color: hoveredHour == hour.hour
                                            ? primaryBlue.withOpacity(0.3)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                          Container(
                            width: tableDayWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            child: SingleChildScrollView(
                              controller: horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var court in widget.viewModel.courts)
                                    widget.viewModel.selectedDayMatches
                                            .firstWhere((element) =>
                                                element.court == court)
                                            .dayMatches
                                            .isEmpty
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: divider,
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.topCenter,
                                            width: tableColumnDataWidth,
                                            height: hourHeight *
                                                widget
                                                    .viewModel
                                                    .selectedDayWorkingHours
                                                    .length,
                                            padding: EdgeInsets.only(
                                              top: defaultPadding,
                                            ),
                                            child: Text(
                                              "${court.description} não aceita mensalistas nesse dia da semana",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              for (var dayMatch in widget
                                                  .viewModel.selectedDayMatches
                                                  .firstWhere((element) =>
                                                      element.court == court)
                                                  .dayMatches)
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: divider,
                                                      ),
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  height: dayMatch.match != null
                                                      ? hourHeight *
                                                          dayMatch.match!
                                                              .matchDuration
                                                      : dayMatch.recurrentMatch !=
                                                              null
                                                          ? hourHeight *
                                                              dayMatch
                                                                  .recurrentMatch!
                                                                  .recurrentMatchDuration
                                                          : hourHeight,
                                                  width: tableColumnDataWidth,
                                                  child: widget.viewModel
                                                              .calendarType ==
                                                          CalendarType.Match
                                                      ? dayMatch.match ==
                                                                  null &&
                                                              dayMatch.recurrentMatch ==
                                                                  null
                                                          ? EmptyHourWidget(
                                                              isEnabled: !isHourPast(
                                                                  widget
                                                                      .viewModel
                                                                      .selectedDay,
                                                                  dayMatch
                                                                      .startingHour),
                                                              onBlockHour: () =>
                                                                  widget
                                                                      .viewModel
                                                                      .setBlockHourWidget(
                                                                context,
                                                                court,
                                                                dayMatch
                                                                    .startingHour,
                                                              ),
                                                            )
                                                          : MatchHourWidget(
                                                              calendarType: widget
                                                                  .viewModel
                                                                  .calendarType,
                                                              match: dayMatch
                                                                  .match,
                                                              recurrentMatch:
                                                                  dayMatch
                                                                      .recurrentMatch,
                                                              onTapMatch: () => widget
                                                                  .viewModel
                                                                  .setMatchDetailsWidget(
                                                                      context,
                                                                      dayMatch
                                                                          .match!),
                                                              onUnblockHour:
                                                                  () => {
                                                                widget.viewModel
                                                                    .unblockHour(
                                                                  context,
                                                                  court
                                                                      .idStoreCourt!,
                                                                  widget
                                                                      .viewModel
                                                                      .selectedDay,
                                                                  dayMatch
                                                                      .startingHour,
                                                                )
                                                              },
                                                              selectedDate: widget
                                                                  .viewModel
                                                                  .selectedDay,
                                                            )
                                                      : dayMatch.recurrentMatch ==
                                                              null
                                                          ? EmptyHourWidget(
                                                              isEnabled: true,
                                                              onBlockHour: () =>
                                                                  widget
                                                                      .viewModel
                                                                      .setRecurrentBlockHourWidget(
                                                                context,
                                                                court,
                                                                dayMatch
                                                                    .startingHour,
                                                              ),
                                                            )
                                                          : MatchHourWidget(
                                                              calendarType: widget
                                                                  .viewModel
                                                                  .calendarType,
                                                              match: dayMatch
                                                                  .match,
                                                              recurrentMatch:
                                                                  dayMatch
                                                                      .recurrentMatch,
                                                              onTapMatch: () => widget
                                                                  .viewModel
                                                                  .setRecurrentMatchDetailsWidget(
                                                                      context,
                                                                      dayMatch
                                                                          .recurrentMatch!),
                                                              onUnblockHour:
                                                                  () => widget
                                                                      .viewModel
                                                                      .recurrentUnblockHour(
                                                                context,
                                                                dayMatch
                                                                    .recurrentMatch!
                                                                    .idRecurrentMatch,
                                                              ),
                                                              selectedDate: widget
                                                                  .viewModel
                                                                  .selectedDay,
                                                            ),
                                                ),
                                            ],
                                          ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
