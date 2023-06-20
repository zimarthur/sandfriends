import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/RewardUser.dart';

class RewardUserAlreadyClaimedModal extends StatelessWidget {
  RewardUser rewardUser;
  RewardUserAlreadyClaimedModal({
    required this.rewardUser,
  });
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: [
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: height * 0.15,
            child: SvgPicture.asset(r"assets\icon\happy_face.svg"),
          ),
          Container(
            alignment: Alignment.center,
            height: height * 0.1,
            child: Text(
              "Você já coleteu essa recompensa no dia ${DateFormat("dd/MM/yyyy").format(rewardUser.rewardClaimedDate!)}",
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: [
              RewardUserAlreadyClaimedItem(
                title: "Objetivo:",
                description: rewardUser.monthReward.description,
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              RewardUserAlreadyClaimedItem(
                title: "Recompensa:",
                description: rewardUser.selectedReward!,
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              RewardUserAlreadyClaimedItem(
                title: "Local:",
                description: rewardUser.store!.name,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RewardUserAlreadyClaimedItem extends StatelessWidget {
  String title;
  String description;
  RewardUserAlreadyClaimedItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textScaleFactor: 0.9,
          style: TextStyle(color: textDarkGrey),
        ),
        SizedBox(
          height: defaultPadding / 4,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
