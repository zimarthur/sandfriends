import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class LoginRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> login(
      BuildContext context, String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.loginUser,
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

  Future<NetworkResponse> forgotPassword(
      BuildContext context, String email) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordRequest,
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
