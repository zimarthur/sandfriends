import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class HomeRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getUserInfo(
    BuildContext context,
    String accessToken,
    Tuple2<bool?, String?>? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getUserInfo,
      jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
          'UpdateNotifications': notificationsConfig != null,
          'AllowNotifications': notificationsConfig != null
              ? notificationsConfig.item1 ?? false
              : false,
          'NotificationsToken': notificationsConfig != null
              ? notificationsConfig.item2 ?? ""
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
