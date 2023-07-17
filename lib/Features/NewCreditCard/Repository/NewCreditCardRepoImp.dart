import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'NewCreditCardRepo.dart';

class NewCreditCardRepoImp implements NewCreditCardRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> addUserCreditCard(
    String accessToken,
    String cardNumber,
    String? nickname,
    DateTime expirationDate,
    String ownerName,
    String ownerCpf,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().addUserCreditCard,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'CardNumber': cardNumber,
          'Nickname': nickname ?? "",
          'ExpirationDate':
              "01/${DateFormat("MM/yyyy").format(expirationDate)}",
          'OwnerName': ownerName,
          'OwnerCpf': ownerCpf,
        },
      ),
    );
    return response;
  }
}
