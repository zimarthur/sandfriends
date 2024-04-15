import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../../Menu/ViewModel/MenuProviderQuadras.dart';
import '../../../ViewModel/CalendarViewModel.dart';
import '../CalendarToggle.dart';
import 'DatePicker.dart';

class MatchFilter extends StatelessWidget {
  CalendarViewModel viewModel;
  MatchFilter({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double width =
        Provider.of<MenuProviderQuadras>(context).getScreenWidth(context);
    double height =
        Provider.of<MenuProviderQuadras>(context).getScreenHeight(context);
    return SizedBox(
      width: 300,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CalendarToggle(
              selectedIndex: viewModel.periodType,
              onChanged: (calType) {
                viewModel.periodType = calType;
              },
              horizontal: true,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            DatePicker(
              onDateSelected: (newDate) {
                viewModel.setSelectedDay(context, newDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
