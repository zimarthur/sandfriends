import 'dart:convert';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import 'LoginRepo.dart';

class LoginRepoImp implements LoginRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> login(String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().login,
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
          'ThirdPartyLogin': false,
        },
      ),
    );
    return response;
  }

  @override
  Future<NetworkResponse> forgotPassword(String email) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().changePasswordRequest,
      jsonEncode(
        <String, Object>{
          "Email": email,
        },
      ),
    );
    return response;
  }
}
