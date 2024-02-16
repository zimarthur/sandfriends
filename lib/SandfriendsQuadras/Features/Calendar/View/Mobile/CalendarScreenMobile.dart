import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/viewport_offset.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/CalendarDatePickerMobile.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/CalendarHeader.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/CalendarWidgetMobile.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/CalendarWidgetMobile.dart';
import 'package:sandfriends_web/Features/Menu/View/Mobile/SFStandardHeader.dart';
import 'package:sandfriends_web/Utils/TypesExtensions.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/SFDateTime.dart';
import '../../ViewModel/CalendarViewModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class CalendarScreenMobile extends StatefulWidget {
  const CalendarScreenMobile({super.key});

  @override
  State<CalendarScreenMobile> createState() => _CalendarScreenMobileState();
}

class _CalendarScreenMobileState extends State<CalendarScreenMobile> {
  final CalendarViewModel viewModel = CalendarViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initCalendarViewModel(context, true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CalendarViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                CalendarHeader(),
                Expanded(
                    child: Column(
                  children: [
                    CalendarDatePickerMobile(),
                    Expanded(child: CalendarWidgetMobile(viewModel: viewModel)),
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
