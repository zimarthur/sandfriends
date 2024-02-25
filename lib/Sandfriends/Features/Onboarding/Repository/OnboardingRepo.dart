import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class OnboardingRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> addUserInfo(
    BuildContext context,
    String accessToken,
    String firstName,
    String lastName,
    String phoneNumber,
    int idCity,
    int idSport,
    String? email,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addUserInfo,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'FirstName': firstName,
          'LastName': lastName,
          'PhoneNumber': phoneNumber,
          'IdCity': idCity,
          'IdSport': idSport,
          if (email != null) 'Email': email,
        },
      ),
    );
    return response;
  }
}
