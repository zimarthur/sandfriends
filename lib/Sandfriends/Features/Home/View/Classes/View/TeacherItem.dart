import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../Common/Model/Classes/Teacher/Teacher.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../Providers/UserProvider/UserProvider.dart';

class TeacherItem extends StatelessWidget {
  Teacher teacher;
  TeacherItem({
    required this.teacher,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SFAvatarUser(
            height: 80,
            user: teacher.user,
            showRank: false,
          ),
          SizedBox(
            height: defaultPadding / 4,
          ),
          AutoSizeText(
            teacher.user.firstName!,
            style: TextStyle(color: textBlue),
            maxLines: 1,
            minFontSize: 10,
            maxFontSize: 14,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
