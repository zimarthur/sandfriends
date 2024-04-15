import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../../Menu/ViewModel/MenuProviderQuadras.dart';
import '../../../Model/PeriodType.dart';
import '../../../ViewModel/CalendarViewModel.dart';
import '../CalendarToggle.dart';
import 'WeekdayPicker.dart';

class RecurrentMatchFilter extends StatelessWidget {
  CalendarViewModel viewModel;
  RecurrentMatchFilter({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double width =
        Provider.of<MenuProviderQuadras>(context).getScreenWidth(context);
    double height =
        Provider.of<MenuProviderQuadras>(context).getScreenHeight(context);
    return SizedBox(
      width: 150,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CalendarToggle(
              selectedIndex: viewModel.periodType,
              onChanged: (calType) {
                viewModel.periodType = calType;
              },
              horizontal: false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            if (viewModel.periodType == PeriodType.Daily)
              WeekdayPicker(
                onChanged: (p0) => viewModel.setSelectedWeekday(p0),
                selectedIndex: viewModel.selectedWeekday,
              ),
          ],
        ),
      ),
    );
  }
}
