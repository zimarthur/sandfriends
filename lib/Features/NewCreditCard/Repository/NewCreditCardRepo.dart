import 'package:flutter/material.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/CreditCard/CardType.dart';

class NewCreditCardRepo {
  Future<NetworkResponse?> addUserCreditCard(
    BuildContext context,
    String accessToken,
    String phoneNumber,
    String cardNumber,
    String nickname,
    DateTime expirationDate,
    String ownerName,
    String ownerCpf,
    String cep,
    String address,
    String addressNumber,
    CardType cardType,
  ) async {
    return null;
  }
}
