import 'package:flutter/material.dart';

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
