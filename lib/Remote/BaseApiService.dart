import 'package:sandfriends/Remote/Url.dart';

abstract class BaseApiService {
  Future<dynamic> getResponse(String url);
  Future<dynamic> postResponse(String url, String body);
}
