import '../../../Remote/NetworkResponse.dart';

class HomeRepo {
  Future<NetworkResponse?> getUserInfo(String accessToken) async {}
  Future<NetworkResponse?> sendFeedback(
      String accessToken, String feedback) async {}
}
