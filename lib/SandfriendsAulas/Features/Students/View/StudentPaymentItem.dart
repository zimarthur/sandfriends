import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';

import '../../../../Common/Components/SFAvatarUser.dart';
import '../../../../Common/Utils/Constants.dart';

class StudentPaymentItem extends StatelessWidget {
  UserClassPayment userClassPayment;
  StudentPaymentItem({
    required this.userClassPayment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(
          context,
          "/student_payment_details",
          arguments: {
            'userClassPayment': userClassPayment,
          },
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: Row(
              children: [
                SFAvatarUser(
                    height: 80, user: userClassPayment.user, showRank: false),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userClassPayment.user.fullName,
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      ),
                      Text(
                        "${userClassPayment.totalMatches.length} aula${userClassPayment.totalMatches.length == 1 ? '' : 's'}",
                        style: TextStyle(color: textLightGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadius,
                    ),
                    color: userClassPayment.hasPaidAllClasses ? greenBg : redBg,
                  ),
                  padding: EdgeInsets.all(
                    defaultPadding / 2,
                  ),
                  child: Text(
                    userClassPayment.totalCost.formatPrice(),
                    style: TextStyle(
                      color: userClassPayment.hasPaidAllClasses
                          ? greenText
                          : redText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: divider,
          ),
        ],
      ),
    );
  }
}
