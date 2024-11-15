import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../Common/Managers/Firebase/NotificationsConfig.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class HomeRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getUserInfo(
    BuildContext context,
    String accessToken,
    NotificationsConfig? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getUserInfo,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'UpdateNotifications': notificationsConfig != null,
          'AllowNotifications': notificationsConfig != null
              ? notificationsConfig.authorized
              : false,
          'NotificationsToken': notificationsConfig != null
              ? notificationsConfig.token ?? ""
              : "",
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> sendFeedback(
      BuildContext context, String accessToken, String feedback) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.sendFeedback,
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
