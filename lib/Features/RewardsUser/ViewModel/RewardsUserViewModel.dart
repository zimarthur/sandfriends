import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardUserAlreadyClaimedModal.dart';
import 'package:sandfriends/Features/RewardsUser/View/RewardUserClaimModal.dart';
import 'package:sandfriends/SharedComponents/Model/RewardUser.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/RewardsUserRepoImp.dart';

class RewardsUserViewModel extends ChangeNotifier {
  final rewardsUserRepo = RewardsUserRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? formWidget;

  String titleText = "Minhas Recompensas";

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
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              pageStatus = PageStatus.OK;
              notifyListeners();
            }
          },
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  void goToRewardsUserScreen(BuildContext context) {
    Navigator.pushNamed(context, '/rewards_user');
  }

  void onTapUserReward(RewardUser userReward) {
    if (userReward.rewardClaimed) {
      formWidget = RewardUserAlreadyClaimedModal(rewardUser: userReward);
    } else {
      formWidget = RewardUserClaimModal(rewardUser: userReward);
    }
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }
}
