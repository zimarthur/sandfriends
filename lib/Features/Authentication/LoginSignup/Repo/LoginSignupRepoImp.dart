import 'dart:convert';

import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import 'LoginSignupRepo.dart';

class LoginSignupRempoImp implements LoginSignupRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> thirdPartyLogin(String email) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().thirdPartyLogin,
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
