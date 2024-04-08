import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';

import '../../../../../../Common/Components/SFAvatarStore.dart';
import '../../../../../../Common/Model/Classes/School/School.dart';
import '../../../../../../Common/Utils/Constants.dart';

class SchoolItem extends StatelessWidget {
  SchoolUser school;
  SchoolItem({
    required this.school,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding / 2, horizontal: defaultPadding / 4),
      decoration: BoxDecoration(
        color: secondaryPaper,
        border: Border.all(
          color: divider,
        ),
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SFAvatarStore(
            height: 60,
            storeName: school.name,
            storePhoto: school.logo,
            enableShadow: true,
          ),
          SizedBox(
            width: defaultPadding / 2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: TextStyle(
                    color: primaryBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      r"assets/icon/court.svg",
                      color: textDarkGrey,
                      height: 15,
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      child: Text(
                        school.store.name,
                        style: TextStyle(
                          color: textDarkGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 4,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      r"assets/icon/location_ping.svg",
                      color: textDarkGrey,
                      height: 15,
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      child: Text(
                        school.store.shortAddress,
                        style: TextStyle(
                          color: textDarkGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: defaultPadding / 2,
          ),
          Row(
            children: [
              Text(
                "ver mais ",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: textDarkGrey,
                  fontSize: 12,
                ),
              ),
              SvgPicture.asset(
                r"assets/icon/chevron_right.svg",
                color: textDarkGrey,
                height: 15,
              ),
            ],
          )
        ],
      ),
    );
  }
}
