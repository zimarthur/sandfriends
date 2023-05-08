import 'package:flutter/material.dart';
import 'package:sandfriends/Features/MatchSearch/View/MatchSearchFilters.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

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
          viewModel: widget.viewModel,
        ),
        Expanded(
          child: Container(
            color: secondaryPaper,
          ),
        ),
      ],
    );
  }
}
