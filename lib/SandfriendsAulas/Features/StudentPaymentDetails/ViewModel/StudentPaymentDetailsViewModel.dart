import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/StudentPaymentDetails/Repo/StudentPaymentDetailsRepo.dart';
import 'package:sandfriends/SandfriendsAulas/Features/StudentPaymentDetails/View/ClassMatchPaymentModal.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/TeamPaymentForUser.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Remote/NetworkResponse.dart';

class StudentPaymentDetailsViewModel extends StandardScreenViewModel {
  final studentPaymentDetailsRepo = StudentPaymentDetailsRepo();

  late UserClassPayment userClassPayment;
  void initStudentPaymentDetaisl(
    BuildContext context,
    UserClassPayment argUserClassPayment,
  ) {
    userClassPayment = argUserClassPayment;
    notifyListeners();
  }

  void onTapMatch(
    BuildContext context,
    AppMatchUser match,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ClassMatchPaymentModal(
        match: match,
        user: userClassPayment.user,
        onUpdateClassPayment: (hasPaid, cost) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .clearOverlays();
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setLoading();
          studentPaymentDetailsRepo
              .updateClassPaymentDetails(
            context,
            Provider.of<EnvironmentProvider>(context, listen: false)
                .accessToken!,
            match.selectedMember!.idMatchMember,
            hasPaid,
            cost,
          )
              .then((response) {
            if (response.responseStatus == NetworkResponseStatus.success) {
              Map<String, dynamic> responseBody = json.decode(
                response.responseBody!,
              );
              match.selectedMember!.hasPaid = responseBody["HasPaid"];
              match.selectedMember!.cost = double.parse(
                responseBody["Cost"],
              );
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addModalMessage(
                SFModalMessage(
                  title: "Aula atualizada",
                  onTap: () {},
                  isHappy: true,
                ),
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
                  isHappy:
                      response.responseStatus == NetworkResponseStatus.alert,
                ),
              );
            }
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .setPageStatusOk();
          });
        },
      ),
    );
  }
}
