import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FinanceItem extends StatelessWidget {
  AppMatchStore match;
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
                    SFAvatarStore(
                      height: 50,
                      isPlayerAvatar: true,
                      user: match.matchCreator,
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          "assets/icon/sport_icon_${match.sport!.idSport}.svg",
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
                      match.matchCreator.fullName,
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${DateFormat('dd/MM').format(match.date)} | ${match.timeBegin.hourString} - ${match.timeEnd.hourString}",
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
