import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/CalendarViewModel.dart';
import 'CalendarDatePickerMobile.dart';
import 'CalendarHeader.dart';
import 'CalendarWidgetMobile.dart';

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
