import 'package:flutter/material.dart';
import 'package:sandfriends/Sandfriends/Features/RewardsUser/View/RewardUserCard.dart';

import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/RewardsUserViewModel.dart';

class RewardsUserWidget extends StatefulWidget {
  final RewardsUserViewModel viewModel;
  const RewardsUserWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<RewardsUserWidget> createState() => _RewardsUserWidgetState();
}

class _RewardsUserWidgetState extends State<RewardsUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: widget.viewModel.userRewards.isNotEmpty
          ? ListView.builder(
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
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Você não tem recompensas.",
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
