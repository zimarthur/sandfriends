import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'LoginRepo.dart';

class LoginRepoImp implements LoginRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> login(
      BuildContext context, String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().login,
      ),
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
          'ThirdPartyLogin': false,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> forgotPassword(
      BuildContext context, String email) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().changePasswordRequest,
      ),
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
