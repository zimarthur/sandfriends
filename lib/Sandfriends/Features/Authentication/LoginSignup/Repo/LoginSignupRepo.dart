import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';

class LoginSignupRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> thirdPartyLogin(
    BuildContext context,
    String email,
    String? appleToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.thirdPartyLogin,
      jsonEncode(
        <String, Object>{
          if (appleToken != null) "AppleToken": appleToken,
          "Email": email,
        },
      ),
    );
    return response;
  }
}
