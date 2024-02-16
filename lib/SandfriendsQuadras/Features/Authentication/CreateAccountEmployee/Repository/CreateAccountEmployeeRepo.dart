import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class CreateAccountEmployeeRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> validateNewEmployeeToken(
      BuildContext context, String token) async {
    dynamic response = await _apiService.postResponse(
      context,
      ApiEndPoints.validateNewEmployeeToken,
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> createAccountEmployee(
    BuildContext context,
    String token,
    String firstName,
    String lastName,
    String password,
  ) async {
    dynamic response = await _apiService.postResponse(
      context,
      ApiEndPoints.createAccountEmployee,
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
          "FirstName": firstName,
          "LastName": lastName,
          "Password": password,
        },
      ),
    );
    return response;
  }
}
