class RewardItem {
  int idRewardItem;
  String description;

  RewardItem({
    required this.idRewardItem,
    required this.description,
  });

  factory RewardItem.fromJson(Map<String, dynamic> parsedJson) {
    return RewardItem(
      idRewardItem: parsedJson["IdRewardItem"],
      description: parsedJson["Description"],
    );
  }
}
