import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchStore.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Components/SFAvatarStore.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Model/SelectedPayment.dart';
import '../../../../../Common/Utils/Constants.dart';

class MatchCard extends StatelessWidget {
  AppMatchStore match;
  MatchCard({
    required this.match,
    super.key,
  });

  double avatarHeight = 70.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: textWhite,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: textLightGrey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: avatarHeight * 1.2,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        primaryBlue,
                        secondaryLightBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultBorderRadius * 1.5),
                      topRight: Radius.circular(
                        defaultBorderRadius * 1.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: avatarHeight + defaultPadding,
                      ),
                      Expanded(
                        child: Text(
                          "${match.isFromRecurrentMatch ? "Mensalista" : "Partida"} de ${match.matchCreator.firstName}",
                          style: TextStyle(
                            color: textWhite,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: textWhite,
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius * 1.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2,
                            vertical: defaultPadding / 4),
                        child: Text(
                          match.court.description,
                          style: TextStyle(color: textBlue, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: textWhite,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(defaultBorderRadius * 1.5),
                      bottomRight: Radius.circular(
                        defaultBorderRadius * 1.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: avatarHeight + defaultPadding,
                      ),
                      Expanded(
                        child: Text(
                          "${match.matchHourDescription}  |  ${match.sport!.description}",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                      ),
                      SvgPicture.asset(
                          match.selectedPayment == SelectedPayment.PayInStore
                              ? r"assets/icon/needs_payment.svg"
                              : r"assets/icon/already_paid.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: SFAvatarStore(
              height: avatarHeight,
              user: match.matchCreator,
              isPlayerAvatar: true,
            ),
          ),
        ],
      ),
    );
  }
}
