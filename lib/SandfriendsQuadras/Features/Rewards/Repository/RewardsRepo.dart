import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import 'package:provider/provider.dart';
import '../../../../Remote/NetworkResponse.dart';

class RewardsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> searchCustomRewards(
    BuildContext context,
    String accessToken,
    DateTime startDate,
    DateTime? endDate,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.searchCustomRewards,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "DateStart": DateFormat("dd/MM/yyyy").format(startDate),
          "DateEnd": endDate == null
              ? DateFormat("dd/MM/yyyy").format(startDate)
              : DateFormat("dd/MM/yyyy").format(endDate),
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> sendUserRewardCode(
    BuildContext context,
    String rewardCode,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.sendUserRewardCode,
      jsonEncode(
        <String, Object>{
          "RewardClaimCode": rewardCode,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> userRewardSelected(
    BuildContext context,
    String accessToken,
    String rewardCode,
    int rewardItem,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.userRewardSelected,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "RewardClaimCode": rewardCode,
          "RewardItem": rewardItem,
        },
      ),
    );
    return response;
  }
}
