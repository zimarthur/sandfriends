import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../Common/Model/Teacher.dart';
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
    return Column(
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
        Text(
          teacher.user.firstName!,
          style: TextStyle(),
        )
      ],
    );
  }
}
