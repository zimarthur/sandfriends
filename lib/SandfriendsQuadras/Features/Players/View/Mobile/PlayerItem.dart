import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Model/User/Player_old.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Model/User/UserStore.dart';
import '../../../../../Common/Utils/Constants.dart';

class PlayerItem extends StatelessWidget {
  UserStore player;
  VoidCallback openWhatsApp;
  PlayerItem({required this.player, required this.openWhatsApp, super.key});

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
                      user: player,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        "assets/icon/sport_${player.preferenceSport!.idSport}.svg",
                        height: 20,
                      ),
                    ),
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
                    Row(
                      children: [
                        Text(
                          player.fullName,
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!player.isStorePlayer)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: defaultPadding / 2,
                            ),
                            child: SvgPicture.asset(
                              r"assets/icon/phone_hand.svg",
                              color: primaryBlue,
                            ),
                          )
                      ],
                    ),
                    Text(
                      "${player.gender!.name} ${player.rank != null ? '| ${player.rank!.name}' : ''}",
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
              InkWell(
                onTap: () {
                  if (player.phoneNumber != null) {
                    openWhatsApp();
                  }
                },
                child: SvgPicture.asset(
                  r"assets/icon/whatsapp.svg",
                  color: player.phoneNumber == null
                      ? divider
                      : player.phoneNumber!.isEmpty
                          ? divider
                          : greenText,
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
