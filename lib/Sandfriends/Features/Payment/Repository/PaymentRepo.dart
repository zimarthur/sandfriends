import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class PaymentRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> deleteCreditCard(
    BuildContext context,
    String accessToken,
    int idCreditCard,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.deleteUserCreditCard,
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
