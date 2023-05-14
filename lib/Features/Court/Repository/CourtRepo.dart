import '../../../Remote/NetworkResponse.dart';

class CourtRepo {
  Future<NetworkResponse?> courtReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {}
}
