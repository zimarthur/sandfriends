abstract class BaseApiService {
  final String sandfriendsUrl = "https://www.sandfriends.com.br/";

  Future<dynamic> getResponse(String baseUrl, String aditionalUrl);
  Future<dynamic> postResponse(
      String baseUrl, String aditionalUrl, String body, bool expectResponse);
}
