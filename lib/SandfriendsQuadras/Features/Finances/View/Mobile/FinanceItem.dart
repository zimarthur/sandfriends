import 'package:flutter/material.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/SharedComponents/Model/Reward.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends_web/SharedComponents/View/SFAvatar.dart';
import 'package:sandfriends_web/Utils/TypesExtensions.dart';
import '../../../../Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinanceItem extends StatelessWidget {
  AppMatch match;
  FinanceItem({required this.match, super.key});

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
              SizedBox(
                height: 50,
                width: 50,
                child: Stack(
                  children: [
                    SFAvatar(
                      height: 50,
                      isPlayerAvatar: true,
                      image: match.matchCreatorPhoto,
                      playerFirstName: match.matchCreatorFirstName,
                      playerLastName: match.matchCreatorLastName,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          "assets/icon/sport_${match.sport!.idSport}.svg",
                          height: 20,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.matchCreatorName,
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${DateFormat('dd/MM').format(match.date)} | ${match.startingHour.hourString} - ${match.endingHour.hourString}",
                      style: TextStyle(
                        color: textLightGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding / 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  color: success50,
                ),
                child: Text(
                  "${match.cost.formatPrice()}",
                  style: TextStyle(
                    color: success,
                    fontSize: 12,
                  ),
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
