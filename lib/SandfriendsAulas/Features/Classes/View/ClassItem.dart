import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Utils/Constants.dart';

class ClassItem extends StatelessWidget {
  AppRecurrentMatchUser recMatch;
  ClassItem({
    required this.recMatch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      padding: EdgeInsets.all(4), //borda
      margin: EdgeInsets.symmetric(
        vertical: defaultPadding,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              defaultPadding / 4,
            ),
            child: Row(
              children: [
                Text(
                  recMatch.team!.name,
                  style: TextStyle(
                    color: textWhite,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: textWhite,
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
            ),
            height: 90,
            padding: EdgeInsets.symmetric(
              vertical: defaultPadding / 2,
              horizontal: defaultPadding / 4,
            ),
            child: Row(
              children: [
                SFAvatarStore(
                  height: 70,
                  enableShadow: true,
                  storeName: recMatch.court.store?.name,
                  storePhoto: recMatch.court.store?.logo,
                ),
                SizedBox(
                  width: defaultPadding / 4,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recMatch.court.store!.name,
                        style: TextStyle(
                          color: textDarkGrey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding / 4,
                      ),
                      Text(
                        recMatch.team!.sport.description,
                        style: TextStyle(
                          color: textLightGrey,
                          fontSize: 10,
                        ),
                      ),
                      if (recMatch.team!.rank != null)
                        Text(
                          recMatch.team!.rank!.name,
                          style: TextStyle(
                            color: textLightGrey,
                            fontSize: 10,
                          ),
                        ),
                      Text(
                        recMatch.team!.gender.name,
                        style: TextStyle(
                          color: textLightGrey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recMatch.matchHourDescription,
                      style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 12,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "6 alunos",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
