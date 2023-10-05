import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/AppInfo/Repository/AppInfoRepo.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';

class AppInfoRepoImp implements AppInfoRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> removeUser(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().removeUser,
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
