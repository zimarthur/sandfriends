import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Payment/Repository/PaymentRepoImp.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/CreditCard/CreditCard.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

class PaymentViewModel extends ChangeNotifier {
  final paymentRepo = PaymentRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

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
          message: "Seu cartão foi removido!",
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
          message: response.userMessage!,
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
