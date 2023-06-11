import '../../../Remote/NetworkResponse.dart';

class MatchSearchRepo {
  Future<NetworkResponse?> searchCourts(
    String accessToken,
    int sportId,
    int cityId,
    DateTime dateStart,
    DateTime dateEnd,
    int timeStart,
    int timeEnd,
  ) async {}
}
