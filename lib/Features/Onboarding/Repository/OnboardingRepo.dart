import 'package:sandfriends/Remote/NetworkResponse.dart';

class OnboardingRepo {
  Future<NetworkResponse?> getAllCities() async {}
  Future<NetworkResponse?> addUserInfo(String accessToken, String firstName,
      String lastName, String phoneNumber, int idCity, int idSport) async {}
}
