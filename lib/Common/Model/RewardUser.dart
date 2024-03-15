import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';

import 'Reward.dart';
import 'Store/StoreComplete.dart';

class RewardUser {
  final int idRewardUser;
  final Reward monthReward;
  final String? selectedReward;
  final bool rewardClaimed;
  final DateTime? rewardClaimedDate;
  final StoreUser? store;
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
          : DateFormat('dd/MM/yyyy').parse("${json['RewardClaimedDate']}"),
      store: json['Store'] == null
          ? null
          : StoreUser.fromJson(
              json['Store'],
            ),
    );
    return newRewardUser;
  }
}
