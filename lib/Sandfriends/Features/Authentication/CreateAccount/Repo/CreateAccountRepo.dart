import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';
import 'CreateAccountRepo.dart';

class CreateAccountRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> createAccount(
      BuildContext context, String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.createAccountUser,
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
