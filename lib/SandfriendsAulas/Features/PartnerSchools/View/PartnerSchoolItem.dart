import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';

import '../../../../Common/Components/SFAvatarStore.dart';
import '../../../../Common/Model/Classes/TeacherSchool/TeacherSchoolUser.dart';
import '../../../../Common/Utils/Constants.dart';

class PartnerSchoolItem extends StatelessWidget {
  TeacherSchoolUser teacherSchool;
  Function(TeacherSchoolUser) onInviteResponse;
  PartnerSchoolItem({
    required this.teacherSchool,
    required this.onInviteResponse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (teacherSchool.waitingApproval) {
          onInviteResponse(teacherSchool);
        }
      },
      child: Column(
        children: [
          if (teacherSchool.waitingApproval)
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    defaultBorderRadius,
                  ),
                  topRight: Radius.circular(
                    defaultBorderRadius,
                  ),
                ),
                color: primaryLightBlue,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/email.svg",
                    height: 20,
                    color: textWhite,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Expanded(
                    child: Text(
                      "${teacherSchool.school.name} enviou um convite",
                      style: TextStyle(
                        color: textWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: teacherSchool.waitingApproval
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(
                        defaultBorderRadius,
                      ),
                      bottomRight: Radius.circular(
                        defaultBorderRadius,
                      ),
                    )
                  : BorderRadius.circular(
                      defaultBorderRadius,
                    ),
              border: Border.all(
                color: teacherSchool.waitingApproval
                    ? primaryLightBlue
                    : primaryBlue,
                width: teacherSchool.waitingApproval ? 2 : 1,
              ),
            ),
            margin: EdgeInsets.only(
              bottom: defaultPadding,
            ),
            padding: EdgeInsets.all(
              defaultPadding / 2,
            ),
            child: Row(
              children: [
                SFAvatarStore(
                  height: 80,
                  storeName: teacherSchool.school.name,
                  storePhoto: teacherSchool.school.logo,
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherSchool.school.name,
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          teacherSchool.school.sport.iconLocation,
                          height: 15,
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          teacherSchool.school.sport.description,
                          style: TextStyle(
                              color: textDarkGrey, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/court.svg",
                          color: textDarkGrey,
                          height: 15,
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          teacherSchool.school.store.name,
                          style: TextStyle(
                              color: textDarkGrey, fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
