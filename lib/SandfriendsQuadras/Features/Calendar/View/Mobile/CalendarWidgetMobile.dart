import 'package:flutter/material.dart';
import '../../../../../Common/Model/Court.dart';
import '../../../../../Common/Model/Hour.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../Model/DayMatch.dart';
import '../../ViewModel/CalendarViewModel.dart';
import 'CalendarEvent.dart';
import 'HourInformationWidget.dart';

double hourColumnWidth = 50;
double rowHeight = 80;
const double minCellWidth = 150;
double columnWidth = minCellWidth;
double calendarLeftPadding = defaultPadding / 2;

class CalendarWidgetMobile extends StatefulWidget {
  CalendarViewModel viewModel;
  CalendarWidgetMobile({
    required this.viewModel,
    super.key,
  });

  @override
  State<CalendarWidgetMobile> createState() => _CalendarWidgetMobileState();
}

class _CalendarWidgetMobileState extends State<CalendarWidgetMobile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
          .animate(_slideAnimationController);
  final headerController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double usefulWidth = MediaQuery.of(context).size.width -
          calendarLeftPadding -
          hourColumnWidth;
      setState(() {
        columnWidth =
            (usefulWidth / widget.viewModel.courts.length) < minCellWidth
                ? minCellWidth
                : (usefulWidth / widget.viewModel.courts.length);
      });

      widget.viewModel.horizontalController.addListener(() {
        headerController.jumpTo(widget.viewModel.horizontalController.offset);
        disposeHourInfo();
      });
      widget.viewModel.verticalController.addListener(() {
        disposeHourInfo();
      });
    });

    super.initState();
  }

  void disposeHourInfo() {
    if (widget.viewModel.showHourInfoMobile) {
      _slideAnimationController.reverse().whenComplete(() {
        widget.viewModel.setShowHourInfo();
      });
    }
  }

  @override
  void dispose() {
    widget.viewModel.verticalController.removeListener(() {});
    widget.viewModel.horizontalController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: calendarLeftPadding,
      ),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (_, layoutConstraints) {
              List<Hour> hours = widget.viewModel.selectedDayWorkingHours;
              List<Court> courts = widget.viewModel.courts;
              return Stack(
                children: [
                  SizedBox(
                    height: layoutConstraints.maxHeight,
                    width: layoutConstraints.maxWidth,
                    child: SingleChildScrollView(
                      controller: widget.viewModel.verticalController,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              for (int hourIndex = 0;
                                  hourIndex < hours.length + 1;
                                  hourIndex++)
                                Container(
                                  width: layoutConstraints.maxWidth,
                                  height: rowHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: textLightGrey,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  padding:
                                      EdgeInsets.only(top: defaultPadding / 2),
                                  child: SizedBox(
                                    width: 50,
                                    child: Text(
                                      hourIndex == 0
                                          ? ""
                                          : hours[hourIndex - 1].hourString,
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                              ),
                              Expanded(
                                child: LayoutBuilder(builder:
                                    (layoutContext, layoutConstraints) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller:
                                        widget.viewModel.horizontalController,
                                    child: Row(
                                      children: [
                                        for (int courtIndex = 0;
                                            courtIndex < courts.length;
                                            courtIndex++)
                                          Builder(builder: (context) {
                                            List<DayMatch> dayMatches = widget
                                                .viewModel.selectedDayMatches
                                                .firstWhere((dayMatch) =>
                                                    dayMatch
                                                        .court.idStoreCourt ==
                                                    courts[courtIndex]
                                                        .idStoreCourt)
                                                .dayMatches;
                                            return Column(
                                              children: [
                                                for (int dayMatchIndex = 0;
                                                    dayMatchIndex <
                                                        dayMatches.length + 1;
                                                    dayMatchIndex++)
                                                  dayMatchIndex == 0
                                                      ? SizedBox(
                                                          width: columnWidth,
                                                          height: rowHeight,
                                                        )
                                                      : Container(
                                                          width: columnWidth,
                                                          height: dayMatches[
                                                                          dayMatchIndex -
                                                                              1]
                                                                      .match !=
                                                                  null
                                                              ? rowHeight *
                                                                  dayMatches[
                                                                          dayMatchIndex -
                                                                              1]
                                                                      .match!
                                                                      .matchDuration
                                                              : dayMatches[dayMatchIndex -
                                                                              1]
                                                                          .recurrentMatch !=
                                                                      null
                                                                  ? rowHeight *
                                                                      dayMatches[dayMatchIndex -
                                                                              1]
                                                                          .recurrentMatch!
                                                                          .recurrentMatchDuration
                                                                  : rowHeight,
                                                          child: CalendarEvent(
                                                            court: courts[
                                                                courtIndex],
                                                            dayMatch: dayMatches[
                                                                dayMatchIndex -
                                                                    1],
                                                            viewModel: widget
                                                                .viewModel,
                                                            onTapDayMatch: () {
                                                              _slideAnimationController
                                                                  .forward();
                                                            },
                                                          ),
                                                        )
                                              ],
                                            );
                                          })
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: hourColumnWidth,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryBack,
                      border: Border(
                        bottom: BorderSide(
                          color: textLightGrey,
                          width: 2,
                        ),
                      ),
                    ),
                    height: rowHeight,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: headerController,
                        scrollDirection: Axis.horizontal,
                        itemCount: courts.length,
                        itemBuilder: (context, courtIndex) {
                          return Container(
                            width: columnWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            child: Text(
                              courts[courtIndex].description,
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
          ),
          if (widget.viewModel.showHourInfoMobile)
            HourInformationWidget(
              slideAnimation: _slideAnimation,
              viewModel: widget.viewModel,
              court: widget.viewModel.hourInformation!.court,
              timeBegin: widget.viewModel.hourInformation!.timeBegin,
              timeEnd: widget.viewModel.hourInformation!.timeEnd,
              onClose: () => disposeHourInfo(),
            ),
        ],
      ),
    );
  }
}
