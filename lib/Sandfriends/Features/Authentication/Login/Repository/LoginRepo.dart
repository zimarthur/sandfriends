import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class LoginRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> login(
    BuildContext context,
    String email,
    String password,
    bool isTeacher,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.loginUser,
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
          'ThirdPartyLogin': false,
          "IsTeacher": isTeacher,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> forgotPassword(
    BuildContext context,
    String email,
    bool isTeacher,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordRequest,
      jsonEncode(
        <String, Object>{
          "Email": email,
          "IsTeacher": isTeacher,
        },
      ),
    );
    return response;
  }
}
