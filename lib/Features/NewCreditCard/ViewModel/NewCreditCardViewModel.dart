import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/NewCreditCard/Repository/NewCreditCardRepoImp.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CardType.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardUtils.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/CreditCard/CreditCard.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

class NewCreditCardViewModel extends ChangeNotifier {
  final newCreditCardRepo = NewCreditCardRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  void initNewCreditCard(BuildContext context) {
    cardNumberController.addListener(() {
      cardType = getCardTypeFromNumber(cardNumberController.text);
      notifyListeners();
    });
  }

  final newCreditCardFormKey = GlobalKey<FormState>();

  TextEditingController cardNicknameController = TextEditingController();
  TextEditingController cardNumberController =
      MaskedTextController(mask: "0000 0000 0000 0000 0000");
  TextEditingController cardExpirationDateController =
      MaskedTextController(mask: "00/0000");
  TextEditingController cardCvvController = MaskedTextController(mask: "0000");
  TextEditingController cardOwnerController = TextEditingController();
  TextEditingController cardCpfController =
      MaskedTextController(mask: "000.000.000-00");
  TextEditingController cardCepController =
      MaskedTextController(mask: "00000-000");
  TextEditingController cardCityController = TextEditingController();
  TextEditingController cardAddressController = TextEditingController();
  TextEditingController cardAddressNumberController = TextEditingController();

  CardType cardType = CardType.Others;

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void addNewCreditCard(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (newCreditCardFormKey.currentState?.validate() == true) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      newCreditCardRepo
          .addUserCreditCard(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        cardNumberController.text.replaceAll(" ", ""),
        cardCvvController.text,
        cardNicknameController.text,
        DateFormat("MM/yyyy").parse(
          cardExpirationDateController.text,
        ),
        cardOwnerController.text,
        cardCpfController.text.replaceAll(RegExp('[^0-9]'), ''),
        cardCepController.text.replaceAll(RegExp('[^0-9]'), ''),
        cardAddressController.text,
        cardAddressNumberController.text,
        cardType,
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
            message: "Seu cartão foi adicionado!",
            onTap: () {
              pageStatus = PageStatus.OK;
              Navigator.pop(context);
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
  }
}
