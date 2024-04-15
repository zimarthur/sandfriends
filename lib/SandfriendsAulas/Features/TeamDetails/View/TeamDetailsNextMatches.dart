import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassItem.dart';

import '../ViewModel/TeamDetailsViewModel.dart';

class TeamDetailsNextMatches extends StatelessWidget {
  const TeamDetailsNextMatches({super.key});

  @override
  Widget build(BuildContext context) {
    TeamDetailsViewModel viewModel = Provider.of<TeamDetailsViewModel>(context);

    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return SizedBox(
        height: layoutConstraints.maxHeight,
        width: layoutConstraints.maxWidth,
        child: ListView.builder(
            itemCount: viewModel.team.teamNextMatches.length,
            itemBuilder: (context, index) {
              return ClassItem(
                team: viewModel.team,
                match: viewModel.team.teamNextMatches[index],
                showDate: true,
              );
            }),
      );
    });
  }
}
