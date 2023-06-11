import '../../../Remote/NetworkResponse.dart';

class CourtRepo {
  Future<NetworkResponse?> matchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {}

  Future<NetworkResponse?> recurrentMatchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {}
}
