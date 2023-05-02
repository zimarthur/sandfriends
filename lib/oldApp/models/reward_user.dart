import 'package:intl/intl.dart';
import 'package:sandfriends/oldApp/models/reward.dart';
import 'package:sandfriends/oldApp/models/store.dart';

class RewardUser {
  final int idRewardUser;
  final Reward monthReward;
  final String? selectedReward;
  final bool rewardClaimed;
  final DateTime? rewardClaimedDate;
  final Store? store;

  RewardUser({
    required this.idRewardUser,
    required this.monthReward,
    this.selectedReward,
    required this.rewardClaimed,
    this.rewardClaimedDate,
    this.store,
  });
}

RewardUser rewardUserFromJson(Map<String, dynamic> json) {
  var newRewardUser = RewardUser(
    idRewardUser: json['IdRewardUser'],
    monthReward: rewardFromJson(json['RewardMonth']),
    selectedReward:
        json['RewardItem'] == null ? null : json['RewardItem']['Description'],
    rewardClaimed: json['RewardClaimed'],
    rewardClaimedDate: json['RewardClaimedDate'] == null
        ? null
        : DateFormat('yyyy-MM-dd').parse("${json['RewardClaimedDate']}"),
    store: json['Store'] == null ? null : storeFromJson(json['Store']),
  );
  return newRewardUser;
}
