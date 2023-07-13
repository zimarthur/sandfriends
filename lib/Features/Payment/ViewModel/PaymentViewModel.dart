import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';

import '../../../SharedComponents/Model/CreditCard/CreditCard.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';

class PaymentViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  List<CreditCard> creditCards = [];
  void initPaymentViewModel(BuildContext context) {
    creditCards = Provider.of<UserProvider>(context, listen: false).creditCards;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
