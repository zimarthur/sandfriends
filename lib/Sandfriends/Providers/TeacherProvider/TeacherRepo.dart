import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Common/Managers/Firebase/NotificationsConfig.dart';

class TeacherRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getTeacherInfo(
    BuildContext context,
    String accessToken,
    NotificationsConfig? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getTeacherInfo,
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
}
