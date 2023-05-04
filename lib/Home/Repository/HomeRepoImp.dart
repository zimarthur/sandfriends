import 'dart:convert';

import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../Remote/ApiEndPoints.dart';
import '../../Remote/BaseApiService.dart';
import '../../Remote/NetworkApiService.dart';
import 'HomeRepo.dart';

class HomeRepoImp implements HomeRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserInfo(String accessToken) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().getUserInfo,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
        },
      ),
    );
    return response;
  }
}
