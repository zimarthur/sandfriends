import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class ForgotPasswordRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> forgotPassword(
      BuildContext context, String email) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.forgotPassword,
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
