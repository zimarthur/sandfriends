import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class LoadLoginRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> validateLogin(
    BuildContext context,
    String? accessToken,
    bool requiresUserToProceed,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.validateTokenUser,
      jsonEncode(
        <String, Object?>{
          "AccessToken": accessToken,
          "RequiresUserToProceed": requiresUserToProceed,
        },
      ),
    );
    return response;
  }
}
