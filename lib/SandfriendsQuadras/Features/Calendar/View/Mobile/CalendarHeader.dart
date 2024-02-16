import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/SFDateTime.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarViewModel viewModel = Provider.of<CalendarViewModel>(context);
    return SFStandardHeader(
      title: "Calendário",
      leftWidget: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: defaultPadding),
            alignment: Alignment.centerLeft,
            child: Text(
              "${monthsPortuguese[getSFMonthIndex(viewModel.selectedDay)]}/${viewModel.selectedDay.year.toString().substring(2)}",
              style: TextStyle(
                color: textWhite,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          InkWell(
            onTap: () => viewModel.onTapColorsDescription(context),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius / 2,
                ),
                border: Border.all(color: textWhite),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    match,
                    recurrentMatch,
                    secondaryYellowDark,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "?",
                  style: TextStyle(
                    color: textWhite,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
      rightWidget: areInTheSameDay(DateTime.now(), viewModel.selectedDay)
          ? Container()
          : Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => viewModel.setSelectedDay(context, DateTime.now()),
                child: Container(
                  margin: EdgeInsets.only(right: defaultPadding),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: textWhite,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadius,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DateTime.now().day.toString(),
                      style: TextStyle(
                        color: textWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
