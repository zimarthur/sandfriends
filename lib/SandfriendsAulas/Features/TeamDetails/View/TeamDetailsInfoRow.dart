import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/ViewModel/TeamDetailsViewModel.dart';

import '../../../../Common/Utils/Constants.dart';

class TeamDetailsInfoRow extends StatelessWidget {
  TeamDetailsViewModel viewModel;
  TeamDetailsInfoRow({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                r"assets/icon/court.svg",
                height: 15,
                color: textDarkGrey,
              ),
              Text(
                viewModel.team.recurrentMatches.length.toString(),
                style: TextStyle(
                  color: primaryLightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "horários",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: textLightGrey,
          width: 2,
          height: 40,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                r"assets/icon/user_group.svg",
                height: 15,
                color: textDarkGrey,
              ),
              Text(
                viewModel.isTeacherCreator
                    ? viewModel.team.membersAndPendinds.length.toString()
                    : viewModel.team.acceptedMembers.length.toString(),
                style: TextStyle(
                  color: primaryLightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "alunos",
                style: TextStyle(
                  color: textDarkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
