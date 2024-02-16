import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/Reward.dart';
import 'package:intl/intl.dart';
import '../../../../Utils/Constants.dart';

class RewardUserItem extends StatelessWidget {
  Reward reward;
  RewardUserItem({required this.reward, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            defaultPadding,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: secondaryYellow,
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                ),
                width: 6,
                height: 60,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.player.fullName,
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Recolheu ",
                          style: TextStyle(
                            color: textLightGrey,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            reward.rewardItem.description,
                            style: TextStyle(
                              color: secondaryYellow,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Text(
                "${DateFormat('dd/MM').format(reward.claimedDate)}\n${DateFormat("HH:mm").format(reward.claimedDate)}",
                style: TextStyle(
                  color: textLightGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: divider,
        ),
      ],
    );
  }
}
