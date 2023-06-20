import 'dart:convert';

import 'package:sandfriends/Features/RewardsUser/Repository/RewardsUserRepo.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';

class RewardsUserRepoImp implements RewardsUserRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserRewards(
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getUserRewards,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
