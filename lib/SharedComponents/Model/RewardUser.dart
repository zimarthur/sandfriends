import 'package:intl/intl.dart';

import 'Reward.dart';
import 'Store.dart';

class RewardUser {
  final int idRewardUser;
  final Reward monthReward;
  final String? selectedReward;
  final bool rewardClaimed;
  final DateTime? rewardClaimedDate;
  final Store? store;
  final String rewardClaimCode;

  RewardUser({
    required this.idRewardUser,
    required this.monthReward,
    this.selectedReward,
    required this.rewardClaimed,
    required this.rewardClaimCode,
    this.rewardClaimedDate,
    this.store,
  });

  factory RewardUser.fromJson(Map<String, dynamic> json) {
    var newRewardUser = RewardUser(
      idRewardUser: json['IdRewardUser'],
      monthReward: Reward.fromJson(json['RewardMonth']),
      rewardClaimCode: json['RewardClaimCode'],
      selectedReward:
          json['RewardItem'] == null ? null : json['RewardItem']['Description'],
      rewardClaimed: json['RewardClaimed'],
      rewardClaimedDate: json['RewardClaimedDate'] == null
          ? null
          : DateFormat('yyyy-MM-dd').parse("${json['RewardClaimedDate']}"),
      store: json['Store'] == null
          ? null
          : Store.fromJson(
              json['Store'],
            ),
    );
    return newRewardUser;
  }
}
