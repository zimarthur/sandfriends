import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class TeacherRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getTeacherInfo(
    BuildContext context,
    String accessToken,
    Tuple2<bool?, String?>? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.getTeacherInfo,
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
}
