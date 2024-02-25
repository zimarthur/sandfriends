import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Payment/Repository/PaymentRepo.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/CreditCard/CreditCard.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';

class PaymentViewModel extends StandardScreenViewModel {
  final paymentRepo = PaymentRepo();

  void onDeleteCreditCard(BuildContext context, CreditCard creditCard) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    paymentRepo
        .deleteCreditCard(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      creditCard.idCreditCard,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<UserProvider>(context, listen: false).clearCreditCards();
        for (var creditCard in responseBody['CreditCards']) {
          Provider.of<UserProvider>(context, listen: false).addCreditCard(
            CreditCard.fromJson(
              creditCard,
            ),
          );
        }
        modalMessage = SFModalMessage(
          title: "Seu cartão foi removido!",
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: true,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              pageStatus = PageStatus.OK;
              notifyListeners();
            }
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );
        if (response.responseStatus == NetworkResponseStatus.expiredToken) {
          canTapBackground = false;
        }
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
