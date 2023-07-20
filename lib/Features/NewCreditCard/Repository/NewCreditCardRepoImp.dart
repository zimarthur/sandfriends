import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/CreditCard/CardType.dart';
import 'NewCreditCardRepo.dart';

class NewCreditCardRepoImp implements NewCreditCardRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> addUserCreditCard(
    String accessToken,
    String cardNumber,
    String cvv,
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
      _apiService.sandfriendsUrl,
      ApiEndPoints().addUserCreditCard,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'CardNumber': cardNumber,
          'Cvv': cvv,
          'Nickname': nickname ?? "",
          'ExpirationDate': "${DateFormat("MM/yyyy").format(expirationDate)}",
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
}
