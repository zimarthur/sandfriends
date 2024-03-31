import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Model/Team.dart';
import '../../../../Common/Utils/Constants.dart';

class TeamItem extends StatelessWidget {
  Team team;
  TeamItem({
    required this.team,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        border: Border.all(
          color: primaryBlue,
        ),
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  team.name,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: primaryBlue,
                  border: Border.all(
                    color: secondaryLightBlue,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      r"assets/icon/user_singular.svg",
                      color: textWhite,
                      height: 15,
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Text(
                      "2",
                      style: TextStyle(color: textWhite),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/class.svg",
                color: textDarkGrey,
                height: 15,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Text(
                "2 aulas",
                style: TextStyle(
                  color: textDarkGrey,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/info_circle.svg",
                color: textDarkGrey,
                height: 15,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Text(
                "${team.sport.description} - ${team.rank == null ? 'qualquer categ.' : team.rank!.name} - ${team.gender.name}",
                style: TextStyle(
                  color: textDarkGrey,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
