import 'dart:convert';
import 'package:sandfriends/Authentication/LoadLogin/Repository/LoadLoginRepo.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';

class LoadLoginRepoImp implements LoadLoginRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> validateLogin(String accessToken) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().validateToken,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
