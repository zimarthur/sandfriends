import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'LoadLoginRepo.dart';

class LoadLoginRepoImp implements LoadLoginRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> validateLogin(
      BuildContext context, String accessToken) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().validateToken,
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
