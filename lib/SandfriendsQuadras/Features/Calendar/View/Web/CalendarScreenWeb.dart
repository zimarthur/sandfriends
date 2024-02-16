import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/Model/CalendarType.dart';
import 'package:sandfriends_web/Features/Calendar/Model/PeriodType.dart';
import 'package:sandfriends_web/Features/Calendar/View/Web/Match/MatchFilter.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/MenuProvider.dart';
import '../../../../SharedComponents/View/SFHeader.dart';
import '../../../../SharedComponents/View/SFTabs.dart';
import 'Calendar/Day/SFCalendarDay.dart';
import 'CalendarToggle.dart';
import 'Calendar/Week/SFCalendarWeek.dart';
import 'Match/DatePicker.dart';
import 'NoCourtsFound.dart';
import 'RecurrentMatch/RecurrentMatchFilter.dart';

class CalendarScreenWeb extends StatefulWidget {
  const CalendarScreenWeb({super.key});

  @override
  State<CalendarScreenWeb> createState() => _CalendarScreenWebState();
}

class _CalendarScreenWebState extends State<CalendarScreenWeb> {
  final CalendarViewModel viewModel = CalendarViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initCalendarViewModel(context, false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);

    return ChangeNotifierProvider<CalendarViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CalendarViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                const SFHeader(
                    header: "Calendário",
                    description:
                        "Acompanhe as partidas agendadas e veja seus mensalistas"),
                SFTabs(
                  tabs: viewModel.tabItems,
                  selectedPosition: viewModel.selectedTab,
                ),
                Expanded(
                  child: Provider.of<DataProvider>(context, listen: false)
                          .courts
                          .isEmpty
                      ? NoCourtsFound()
                      : viewModel.selectedTab.name == ""
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: LayoutBuilder(builder:
                                      (layoutContext, layoutConstraints) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: secondaryPaper,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding,
                                      ),
                                      child: viewModel.periodType ==
                                              PeriodType.Weekly
                                          ? SFCalendarWeek(
                                              viewModel: viewModel,
                                              height:
                                                  layoutConstraints.maxHeight,
                                              width: layoutConstraints.maxWidth,
                                            )
                                          : SFCalendarDay(
                                              viewModel: viewModel,
                                              height:
                                                  layoutConstraints.maxHeight,
                                              width: layoutConstraints.maxWidth,
                                            ),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: defaultPadding,
                                ),
                                viewModel.calendarType == CalendarType.Match
                                    ? MatchFilter(
                                        viewModel: viewModel,
                                      )
                                    : RecurrentMatchFilter(
                                        viewModel: viewModel,
                                      ),
                              ],
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
