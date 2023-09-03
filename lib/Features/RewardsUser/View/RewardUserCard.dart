import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SharedComponents/Model/RewardUser.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/SFDateTime.dart';

class RewardUserCard extends StatelessWidget {
  final RewardUser userReward;
  const RewardUserCard({
    Key? key,
    required this.userReward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: userReward.rewardClaimed == true
              ? secondaryYellow.withOpacity(0.5)
              : secondaryYellow,
          width: 1,
        ),
        color: userReward.rewardClaimed == true
            ? secondaryYellow.withOpacity(0.1)
            : secondaryYellow.withOpacity(0.6),
      ),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.005, horizontal: width * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 15,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "${monthsPortugueseComplete[userReward.monthReward.startingDate.month - 1]} de ${userReward.monthReward.startingDate.year}",
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.2,
                  child: SvgPicture.asset(r"assets/icon/medal.svg"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.04,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: width * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userReward.monthReward.description,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AutoSizeText(
                          userReward.rewardClaimed
                              ? "Você já coletou essa recompensa"
                              : "Toque para coletar sua recompensa",
                          style: TextStyle(
                            color: userReward.rewardClaimed
                                ? textLightGrey
                                : textDarkGrey,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
