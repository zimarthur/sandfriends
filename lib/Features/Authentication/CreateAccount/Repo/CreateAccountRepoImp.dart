import 'dart:convert';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/BaseApiService.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import 'CreateAccountRepo.dart';

class CreateAccountRepoImp implements CreateAccountRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> createAccount(String email, String password) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().createAccount,
      jsonEncode(
        <String, Object>{
          "Email": email,
          "Password": password,
        },
      ),
    );
    return response;
  }
}
