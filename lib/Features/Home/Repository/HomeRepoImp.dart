import 'dart:convert';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
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

  @override
  Future<NetworkResponse> sendFeedback(
      String accessToken, String feedback) async {
    NetworkResponse response = await _apiService.postResponse(
      _apiService.sandfriendsUrl,
      ApiEndPoints().sendFeedback,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'Feedback': feedback,
        },
      ),
    );
    return response;
  }
}
