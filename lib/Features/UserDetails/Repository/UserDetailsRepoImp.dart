import 'dart:convert';

import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../SharedComponents/Model/User.dart';
import 'UserDetailsRepo.dart';

class UserDetailsRepoImp implements UserDetailsRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> updateUserInfo(String accessToken, User user) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().updateUserInfo,
      jsonEncode(
        user.toJson(),
      ),
    );
    return response;
  }
}
