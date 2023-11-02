import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../Remote/ApiEndPoints.dart';
import '../../../Remote/BaseApiService.dart';
import '../../../Remote/NetworkApiService.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import 'HomeRepo.dart';

class HomeRepoImp implements HomeRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<NetworkResponse> getUserInfo(
    BuildContext context,
    String accessToken,
    Tuple2<bool?, String?>? notificationsConfig,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().getUserInfo,
      ),
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

  @override
  Future<NetworkResponse> sendFeedback(
      BuildContext context, String accessToken, String feedback) async {
    NetworkResponse response = await _apiService.postResponse(
      Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        ApiEndPoints().sendFeedback,
      ),
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
