import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Authentication/EmailConfirmation/Repository/EmailConfirmationRepo.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';

class EmailConfirmationRepoImp implements EmailConfirmationRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> confirmEmail(
      BuildContext context, String token) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().emailConfirmation,
      ),
      jsonEncode(
        <String, Object>{
          "EmailConfirmationToken": token,
        },
      ),
    );
    return response;
  }
}
