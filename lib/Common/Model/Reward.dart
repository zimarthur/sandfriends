import 'package:intl/intl.dart';

class Reward {
  final String description;
  int rewardQuantity;
  int? userRewardQuantity;
  final DateTime startingDate;
  final DateTime endingDate;
  final List<String> rewards = [];

  Reward({
    required this.description,
    required this.rewardQuantity,
    this.userRewardQuantity,
    required this.startingDate,
    required this.endingDate,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    var newReward = Reward(
      description: json['RewardCategory']['Description']
          .toString()
          .replaceAll("{x}", "${json['NTimesToReward']}"),
      rewardQuantity: json['NTimesToReward'],
      startingDate: DateFormat('dd/MM/yyyy').parse("${json['StartingDate']}"),
      endingDate: DateFormat('dd/MM/yyyy').parse("${json['EndingDate']}"),
    );

    for (int i = 0; i < json['Rewards'].length; i++) {
      newReward.rewards.add(json['Rewards'][i]['RewardItem']['Description']);
    }
    return newReward;
  }
}
