import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class RewardsUserRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getUserRewards(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getUserRewards,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
