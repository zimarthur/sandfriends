import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../../Remote/NetworkResponse.dart';

class HomeRepo {
  Future<NetworkResponse?> getUserInfo(
    BuildContext context,
    String accessToken,
    Tuple2<bool?, String?>? notificationsConfig,
  ) async {
    return null;
  }

  Future<NetworkResponse?> sendFeedback(
    BuildContext context,
    String accessToken,
    String feedback,
  ) async {
    return null;
  }
}
