import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/RewardsUser/Repository/RewardsUserRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';

class RewardsUserRepoImp implements RewardsUserRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserRewards(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getUserRewards,
      ),
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
