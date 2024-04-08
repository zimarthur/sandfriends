import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

class StudentsScreenAulasViewModel extends MenuProviderAulas {
  List<UserClassPayment> classPaymentUsers = [];
  void initStudentsViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.Students,
    );
    Provider.of<TeacherProvider>(context, listen: false)
        .matches
        .forEach((match) {
      print(match.team);
      match.members.forEach((member) {
        print(member.user);
      });
    });

    notifyListeners();
  }

  TextEditingController nameFilterController = TextEditingController();

  void filterName(BuildContext context) {}
}
