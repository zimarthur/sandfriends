import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'LoginSignupRepo.dart';

class LoginSignupRempoImp implements LoginSignupRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> thirdPartyLogin(
      BuildContext context, String email) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().thirdPartyLogin,
      ),
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
