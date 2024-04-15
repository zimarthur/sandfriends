import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/ConfirmationModal.dart';
import 'package:sandfriends/Common/Model/Classes/TeacherSchool/TeacherSchool.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/PartnerSchools/Repo/PartnerSchoolsRepo.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Model/Classes/TeacherSchool/TeacherSchoolUser.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';

class PartnerSchoolsViewModel extends StandardScreenViewModel {
  final partnerSchoolsRepo = PartnerSchoolsRepo();

  void onInviteResponse(BuildContext context, TeacherSchoolUser teacherSchool) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ConfirmationModal(
        message: "Deseja entrar na escola ${teacherSchool.school.name}",
        onConfirm: () => inviteResponse(context, teacherSchool, true),
        onCancel: () => inviteResponse(context, teacherSchool, false),
        isHappy: true,
      ),
    );
  }

  void inviteResponse(
    BuildContext context,
    TeacherSchool teacherSchool,
    bool accepted,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    partnerSchoolsRepo
        .schoolInvitationResponse(
            context,
            Provider.of<EnvironmentProvider>(context, listen: false)
                .accessToken!,
            teacherSchool,
            accepted)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<TeacherProvider>(context, listen: false)
            .schoolTeacherResponse(
          TeacherSchoolUser.fromJson(
            responseBody["SchoolTeacher"],
            Provider.of<CategoriesProvider>(context, listen: false).hours,
            Provider.of<CategoriesProvider>(context, listen: false).sports,
            Provider.of<CategoriesProvider>(context, listen: false).ranks,
            Provider.of<CategoriesProvider>(context, listen: false).genders,
          ),
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
