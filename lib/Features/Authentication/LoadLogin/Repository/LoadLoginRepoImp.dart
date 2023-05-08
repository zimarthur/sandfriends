import 'dart:convert';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import 'LoadLoginRepo.dart';

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
