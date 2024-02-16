import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class ChangePasswordRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> validateChangePasswordTokenUser(
    BuildContext context,
    String token,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordValidateTokenUser,
      jsonEncode(
        <String, Object>{
          "ChangePasswordToken": token,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> validateChangePasswordTokenEmployee(
    BuildContext context,
    String token,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordValidateTokenEmployee,
      jsonEncode(
        <String, Object>{
          "ChangePasswordToken": token,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> changePasswordUser(
    BuildContext context,
    String token,
    String newPassword,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordUser,
      jsonEncode(
        <String, Object>{
          "ChangePasswordToken": token,
          "NewPassword": newPassword,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> changePasswordEmployee(
      BuildContext context, String token, String newPassword) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.changePasswordEmployee,
      jsonEncode(
        <String, Object>{
          "ResetPasswordToken": token,
          "NewPassword": newPassword,
        },
      ),
    );
    return response;
  }
}
