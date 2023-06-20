import 'package:flutter/material.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/View/AvailableDaysResult/AvailableDaysResult.dart';
import '../../MatchSearch/View/MatchSearchFilters.dart';
import '../../MatchSearch/View/MatchSearchOnboarding.dart';
import '../../MatchSearch/View/NoMachesFound.dart';
import '../ViewModel/RecurrentMatchSearchViewModel.dart';

class RecurrentMatchSearchWidget extends StatefulWidget {
  RecurrentMatchSearchViewModel viewModel;
  RecurrentMatchSearchWidget({Key? key, 
    required this.viewModel,
  }) : super(key: key);

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
          onTapSearch: () => widget.viewModel.searchRecurrentCourts(context),
          primaryColor: primaryLightBlue,
        ),
        Expanded(
          child: Container(
            color: secondaryBack,
            child: !widget.viewModel.hasUserSearched
                ? MatchSearchOnboarding(
                    isRecurrent: true,
                  )
                : widget.viewModel.availableDays.isEmpty
                    ? NoMatchesFound(
                        isRecurrent: true,
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            AvailableDaysResult(
                              availableDays: widget.viewModel.availableDays,
                              selectedAvailableDay:
                                  widget.viewModel.selectedDay,
                              selectedAvailableHour:
                                  widget.viewModel.selectedHour,
                              selectedStore: widget.viewModel.selectedStore,
                              onTapHour: (avDay) =>
                                  widget.viewModel.onSelectedHour(avDay),
                              onGoToCourt: (store) =>
                                  widget.viewModel.goToCourt(context, store),
                              isRecurrent: true,
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
