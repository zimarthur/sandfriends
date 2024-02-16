import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class UserMatchesRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getUserMatches(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getUserMatches,
      jsonEncode({
        'AccessToken': accessToken,
      }),
    );
    return response;
  }
}
