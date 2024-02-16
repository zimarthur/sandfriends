import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class EmailConfirmationRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> emailConfirmationUser(
      BuildContext context, String token) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.emailConfirmationUser,
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> emailConfirmationStore(
      BuildContext context, String token) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.emailConfirmationStore,
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
        },
      ),
    );
    return response;
  }
}
