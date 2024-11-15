import 'package:flutter/material.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/SearchOnboarding.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/NoMachesFound.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/OpenMatchesResult.dart';

import '../../../../Common/Components/AvailableDaysResult/AvailableDaysResult.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/MatchSearchViewModel.dart';
import 'MatchSearchFilters.dart';

class MatchSearchWidget extends StatefulWidget {
  final MatchSearchViewModel viewModel;
  const MatchSearchWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
                ? const SearchOnboarding(
                    isSearchingStores: false,
                    primaryColor: primaryBlue,
                  )
                : widget.viewModel.availableDays.isEmpty
                    ? const NoMatchesFound()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            if (widget.viewModel.openMatches.isNotEmpty)
                              OpenMatchesResult(
                                viewModel: widget.viewModel,
                              ),
                            AvailableDaysResult(
                              availableDays: widget.viewModel.availableDays,
                              onTapHour: (avDay) =>
                                  widget.viewModel.onSelectedHour(avDay),
                              onGoToCourt: (store) =>
                                  widget.viewModel.goToCourt(context, store),
                              selectedAvailableDay:
                                  widget.viewModel.selectedDay,
                              selectedStore: widget.viewModel.selectedStore,
                              selectedAvailableHour:
                                  widget.viewModel.selectedHour,
                              isRecurrent: false,
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
