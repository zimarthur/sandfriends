import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/RewardsUser/View/RewardUserAlreadyClaimedModal.dart';
import 'package:sandfriends/Sandfriends/Features/RewardsUser/View/RewardUserClaimModal.dart';
import 'package:sandfriends/Common/Model/RewardUser.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Repository/RewardsUserRepo.dart';

class RewardsUserViewModel extends ChangeNotifier {
  final rewardsUserRepo = RewardsUserRepo();

  List<RewardUser> userRewards = [];

  void initRewardsUserScreen(BuildContext context) {
    rewardsUserRepo
        .getUserRewards(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        for (var userReward in responseBody['UserRewards']) {
          userRewards.add(
            RewardUser.fromJson(
              userReward,
            ),
          );
        }
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: false,
          ),
        );
        if (response.responseStatus == NetworkResponseStatus.expiredToken) {
          //canTapBackground = false;
        }
      }
    });
  }

  void goToRewardsUserScreen(BuildContext context) {
    Navigator.pushNamed(context, '/rewards_user');
  }

  void onTapUserReward(BuildContext context, RewardUser userReward) {
    if (userReward.rewardClaimed) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addOverlayWidget(
        RewardUserAlreadyClaimedModal(
          rewardUser: userReward,
        ),
      );
    } else {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addOverlayWidget(
        RewardUserClaimModal(
          rewardUser: userReward,
        ),
      );
    }
  }
}
