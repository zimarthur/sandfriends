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
    int? idCreditCard,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMatchReservation(
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    List<DateTime> currentMonthDates,
    int timeBegin,
    int timeEnd,
    int cost,
    int totalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
    bool isRenovating,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMonthAvailableHours(
    String accessToken,
    int weekday,
    int timeBegin,
    int timeEnd,
    int idStoreCourt,
    bool isRenovating,
  ) async {
    return null;
  }
}
