import 'package:sandfriends/Remote/Url.dart';

abstract class BaseApiService {
  final String sandfriendsUrl = sandfriendsRequestsUrl;

  Future<dynamic> getResponse(String baseUrl, String aditionalUrl);
  Future<dynamic> postResponse(
      String baseUrl, String aditionalUrl, String body);
}
