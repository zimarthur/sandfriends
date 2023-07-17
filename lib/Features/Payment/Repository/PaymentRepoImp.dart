import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'PaymentRepo.dart';

class PaymentRepoImp implements PaymentRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> deleteCreditCard(
    String accessToken,
    int idCreditCard,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().deleteUserCreditCard,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'IdUserCreditCard': idCreditCard,
        },
      ),
    );
    return response;
  }
}
