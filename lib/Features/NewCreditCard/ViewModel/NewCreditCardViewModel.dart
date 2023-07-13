import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CardType.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardUtils.dart';

import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

class NewCreditCardViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  void initNewCreditCard(BuildContext context) {
    cardNumberController.addListener(() {
      cardType = getCardTypeFrmNumber(cardNumberController.text);
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
  TextEditingController cardCpfController = TextEditingController();

  CardType cardType = CardType.Others;

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void addNewCreditCard(BuildContext context) {
    if (newCreditCardFormKey.currentState?.validate() == true) {}
  }
}
