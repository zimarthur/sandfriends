import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'PaymentRepo.dart';

class PaymentRepoImp implements PaymentRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> deleteCreditCard(
    BuildContext context,
    String accessToken,
    int idCreditCard,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().deleteUserCreditCard,
      ),
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
