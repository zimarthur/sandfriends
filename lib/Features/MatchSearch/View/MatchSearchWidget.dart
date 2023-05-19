import 'package:flutter/material.dart';
import 'package:sandfriends/Features/MatchSearch/View/AvailableDaysResult.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchOnboarding.dart';
import 'package:sandfriends/Features/MatchSearch/View/NoMachesFound.dart';
import 'package:sandfriends/Features/MatchSearch/View/OpenMatchesResult.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/MatchSearchViewModel.dart';
import 'MatchSearchFilters.dart';

class MatchSearchWidget extends StatefulWidget {
  MatchSearchViewModel viewModel;
  MatchSearchWidget({
    required this.viewModel,
  });

  @override
  State<MatchSearchWidget> createState() => _MatchSearchWidgetState();
}

class _MatchSearchWidgetState extends State<MatchSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MatchSearchFilters(
          city: widget.viewModel.cityFilter,
          dates: widget.viewModel.datesFilter,
          time: widget.viewModel.timeFilter,
          openCitySelector: () =>
              widget.viewModel.openCitySelectorModal(context),
          openDateSelector: () =>
              widget.viewModel.openDateSelectorModal(context),
          openTimeSelector: () =>
              widget.viewModel.openTimeSelectorModal(context),
          onTapSearch: () => widget.viewModel.searchCourts(context),
          primaryColor: primaryBlue,
        ),
        Expanded(
          child: Container(
            color: secondaryBack,
            child: !widget.viewModel.hasUserSearched
                ? MatchSearchOnboarding()
                : widget.viewModel.availableDays.isEmpty
                    ? NoMatchesFound()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            OpenMatchesResult(
                              viewModel: widget.viewModel,
                            ),
                            AvailableDaysResult(
                              viewModel: widget.viewModel,
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}
