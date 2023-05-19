import 'package:flutter/material.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../MatchSearch/View/MatchSearchFilters.dart';
import '../ViewModel/RecurrentMatchSearchViewModel.dart';

class RecurrentMatchSearchWidget extends StatefulWidget {
  RecurrentMatchSearchViewModel viewModel;
  RecurrentMatchSearchWidget({
    required this.viewModel,
  });

  @override
  State<RecurrentMatchSearchWidget> createState() =>
      _RecurrentMatchSearchWidgetState();
}

class _RecurrentMatchSearchWidgetState
    extends State<RecurrentMatchSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MatchSearchFilters(
          city: widget.viewModel.cityFilter,
          days: widget.viewModel.datesFilter,
          time: widget.viewModel.timeFilter,
          openCitySelector: () =>
              widget.viewModel.openCitySelectorModal(context),
          openDateSelector: () =>
              widget.viewModel.openDateSelectorModal(context),
          openTimeSelector: () =>
              widget.viewModel.openTimeSelectorModal(context),
          onTapSearch: () => widget.viewModel.searchCourts(context),
          primaryColor: secondaryLightBlue,
        ),
        Expanded(
          child: Container(
            color: secondaryBack,
          ),
        ),
      ],
    );
  }
}
