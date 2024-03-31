import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/ConfirmationModal.dart';
import 'package:sandfriends/Common/Model/School/SchoolTeacher.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/PartnerSchools/Repo/PartnerSchoolsRepo.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';

class PartnerSchoolsViewModel extends StandardScreenViewModel {
  final partnerSchoolsRepo = PartnerSchoolsRepo();

  void onInviteResponse(BuildContext context, SchoolTeacher school) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ConfirmationModal(
        message: "Deseja entrar na escola ${school.name}",
        onConfirm: () => inviteResponse(context, school, true),
        onCancel: () => inviteResponse(context, school, false),
        isHappy: true,
      ),
    );
  }

  void inviteResponse(
    BuildContext context,
    SchoolTeacher school,
    bool accepted,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    partnerSchoolsRepo
        .schoolInvitationResponse(
            context,
            Provider.of<UserProvider>(context, listen: false).user!.accessToken,
            school.teacherInformation,
            accepted)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<TeacherProvider>(context, listen: false)
            .schoolTeacherResponse(
          SchoolTeacher.fromJson(responseBody["SchoolTeacher"],
              Provider.of<CategoriesProvider>(context, listen: false).sports),
          accepted,
        );
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: false,
          ),
        );
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .removeLastOverlay();
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }
}
