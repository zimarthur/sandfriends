import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/RewardUser.dart';

class RewardUserClaimModal extends StatelessWidget {
  RewardUser rewardUser;
  RewardUserClaimModal({
    Key? key,
    required this.rewardUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            color: primaryDarkBlue,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.05,
      ),
      width: width * 0.9,
      height: height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: height * 0.1,
            child: SvgPicture.asset(r"assets\icon\happy_face.svg"),
          ),
          SizedBox(
            height: height * 0.1,
            child: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Colete sua recompensa!",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.05,
            child: Text(
              "Apresente o código abaixo a um estabelecimento parceiro",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: height * 0.1,
            child: Text(
              "${rewardUser.rewardClaimCode}",
              textScaleFactor: 2,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: textBlue, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: height * 0.03,
            child: Text(
              "e informe qual recompensa você deseja:",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: height * 0.1,
            child: ListView.builder(
              itemCount: rewardUser.monthReward.rewards.length,
              itemBuilder: (context, rewardIndex) {
                return Text(
                  "- ${rewardUser.monthReward.rewards[rewardIndex]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: textBlue, fontWeight: FontWeight.w500),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
