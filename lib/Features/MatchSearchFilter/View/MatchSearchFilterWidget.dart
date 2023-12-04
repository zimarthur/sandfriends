import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/MatchSearchFilter/ViewModel/MatchSearchFilterViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFTabs.dart';
import 'package:sandfriends/Utils/Constants.dart';

class MatchSearchFilterWidget extends StatefulWidget {
  const MatchSearchFilterWidget({super.key});

  @override
  State<MatchSearchFilterWidget> createState() =>
      _MatchSearchFilterWidgetState();
}

class _MatchSearchFilterWidgetState extends State<MatchSearchFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MatchSearchFilterViewModel>(
      context,
    );
    return Container(
      color: secondaryBack,
      child: Column(
        children: [
          Container(
            color: secondaryPaper,
            child: SFTabs(
              tabs: viewModel.tabs,
              selectedPosition: viewModel.selectedTab,
            ),
          ),
          Expanded(
            child: viewModel.selectedTab.displayWidget,
          ),
        ],
      ),
    );
  }
}
