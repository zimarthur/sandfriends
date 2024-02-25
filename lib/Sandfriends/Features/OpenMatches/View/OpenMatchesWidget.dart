import 'package:flutter/material.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/OpenMatchCard.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../ViewModel/OpenMatchesViewModel.dart';

class OpenMatchesWidget extends StatefulWidget {
  final OpenMatchesViewModel viewModel;
  const OpenMatchesWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<OpenMatchesWidget> createState() => _OpenMatchesWidgetState();
}

class _OpenMatchesWidgetState extends State<OpenMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryPaper,
      child: ListView.builder(
        itemCount: widget.viewModel.openMatches.length,
        itemBuilder: (context, index) {
          return Container(
            height: 220,
            margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: OpenMatchCard(
              isReduced: false,
              match: widget.viewModel.openMatches[index],
              onTap: (matchUrl) =>
                  widget.viewModel.onTapOpenMatch(context, matchUrl),
            ),
          );
        },
      ),
    );
  }
}
