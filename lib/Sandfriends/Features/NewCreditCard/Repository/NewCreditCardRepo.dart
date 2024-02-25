import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Remote/Url.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/CreditCard/CardType.dart';

class NewCreditCardRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addUserCreditCard(
    BuildContext context,
    String accessToken,
    String phoneNumber,
    String cardNumber,
    String? nickname,
    DateTime expirationDate,
    String ownerName,
    String ownerCpf,
    String cep,
    String address,
    String addressNumber,
    CardType cardType,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addUserCreditCard,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'PhoneNumber': phoneNumber,
          'CardNumber': cardNumber,
          'Nickname': nickname ?? "",
          'ExpirationDate': DateFormat("MM/yyyy").format(expirationDate),
          'OwnerName': ownerName,
          'OwnerCpf': ownerCpf,
          'Cep': cep,
          'Address': address,
          'AddressNumber': addressNumber,
          'Issuer': cardTypeToString(cardType),
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> getCepInfo(
    BuildContext context,
    String cep,
  ) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      "",
      completeUrl: "$cepInfo/$cep/json/",
    );
    return response;
  }
}
