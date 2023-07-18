import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';

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
    SelectedPayment selectedPayment,
    String cpf,
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
    SelectedPayment selectedPayment,
    String cpf,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMonthAvailableHours(
    String accessToken,
    int weekday,
    int timeBegin,
    int timeEnd,
    int idStoreCourt,
  ) async {
    return null;
  }
}
