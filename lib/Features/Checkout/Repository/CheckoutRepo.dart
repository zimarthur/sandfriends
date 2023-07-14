import '../../../Remote/NetworkResponse.dart';

class CheckoutRepo {
  Future<NetworkResponse?> matchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMatchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    int timeBegin,
    int timeEnd,
    int cost,
  ) async {
    return null;
  }
}
