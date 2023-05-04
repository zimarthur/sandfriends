import 'dart:convert';

import 'package:sandfriends/Authentication/CreateAccount/Repo/CreateAccountRepo.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';

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
