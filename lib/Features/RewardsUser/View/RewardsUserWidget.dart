import 'package:flutter/material.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardUserCard.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/RewardsUserViewModel.dart';

class RewardsUserWidget extends StatefulWidget {
  RewardsUserViewModel viewModel;
  RewardsUserWidget({
    required this.viewModel,
  });

  @override
  State<RewardsUserWidget> createState() => _RewardsUserWidgetState();
}

class _RewardsUserWidgetState extends State<RewardsUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: ListView.builder(
        itemCount: widget.viewModel.userRewards.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => widget.viewModel
                .onTapUserReward(widget.viewModel.userRewards[index]),
            child: RewardUserCard(
              userReward: widget.viewModel.userRewards[index],
            ),
          );
        },
      ),
    );
  }
}
