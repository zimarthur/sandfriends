import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class EmailConfirmationRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> confirmEmail(
      BuildContext context, String token) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.emailConfirmation,
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
        },
      ),
    );
    return response;
  }
}
