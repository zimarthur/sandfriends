import 'dart:convert';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import 'UserMatchesRepo.dart';

class UserMatchesRepoImp implements UserMatchesRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserMatches(
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().updateUserInfo,
      jsonEncode({
        'AccessToken': accessToken,
      }),
    );
    return response;
  }
}
