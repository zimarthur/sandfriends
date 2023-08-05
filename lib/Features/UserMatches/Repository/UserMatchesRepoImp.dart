import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'UserMatchesRepo.dart';

class UserMatchesRepoImp implements UserMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserMatches(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getUserMatches,
      ),
      jsonEncode({
        'AccessToken': accessToken,
      }),
    );
    return response;
  }
}
