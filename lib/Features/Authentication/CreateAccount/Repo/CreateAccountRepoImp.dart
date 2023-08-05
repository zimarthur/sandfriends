import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'CreateAccountRepo.dart';

class CreateAccountRepoImp implements CreateAccountRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> createAccount(
      BuildContext context, String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().createAccount,
      ),
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
        },
      ),
    );
    return response;
  }
}
