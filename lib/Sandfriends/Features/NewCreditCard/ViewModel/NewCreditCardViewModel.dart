import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/Repository/NewCreditCardRepo.dart';
import 'package:sandfriends/Common/Model/CreditCard/CardType.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardUtils.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/CreditCard/CreditCard.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';

class NewCreditCardViewModel extends StandardScreenViewModel {
  final newCreditCardRepo = NewCreditCardRepo();

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
  TextEditingController cardOwnerController = TextEditingController();
  TextEditingController cardCpfController =
      MaskedTextController(mask: "000.000.000-00");
  TextEditingController cardCepController =
      MaskedTextController(mask: "00000-000");
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(00) 00000-00000');
  final formKey = GlobalKey<FormState>();
  TextEditingController cardCityController = TextEditingController();
  TextEditingController cardAddressController = TextEditingController();
  TextEditingController cardAddressNumberController = TextEditingController();
  TextEditingController cardAddressComplementController =
      TextEditingController();

  CardType cardType = CardType.Others;

  void addNewCreditCard(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (newCreditCardFormKey.currentState?.validate() == true) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      newCreditCardRepo
          .addUserCreditCard(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        phoneNumberController.text.replaceAll(RegExp('[^0-9]'), ''),
        cardNumberController.text.replaceAll(" ", ""),
        cardNicknameController.text,
        DateFormat("MM/yyyy").parse(
          cardExpirationDateController.text,
        ),
        cardOwnerController.text,
        cardCpfController.text.replaceAll(RegExp('[^0-9]'), ''),
        cardCepController.text.replaceAll(RegExp('[^0-9]'), ''),
        cardAddressController.text,
        "${cardAddressNumberController.text} ${cardAddressComplementController.text}",
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
            title: "Seu cartão foi adicionado!",
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
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
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
  }

  void onCepChanged(BuildContext context) {
    String cep = cardCepController.text.replaceAll(
      RegExp('[^0-9]'),
      '',
    );
    if (cep.length == 8) {
      FocusScope.of(context).unfocus();
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      try {
        newCreditCardRepo.getCepInfo(context, cep).then((response) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          if (responseBody.containsKey("erro")) {
            modalMessage = SFModalMessage(
              title: "CEP não encontrado",
              onTap: () {
                pageStatus = PageStatus.OK;
                notifyListeners();
              },
              isHappy: false,
            );
            pageStatus = PageStatus.ERROR;
            notifyListeners();
          } else {
            cardCityController.text =
                "${responseBody['localidade']} - ${responseBody['uf']}";
            cardAddressController.text = responseBody['logradouro'];
            pageStatus = PageStatus.OK;
            notifyListeners();
          }
        });
      } catch (e) {}
    }
  }
}