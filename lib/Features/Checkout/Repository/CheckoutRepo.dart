import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';

import '../../../Remote/NetworkResponse.dart';
import '../Model/Coupon.dart';

class CheckoutRepo {
  Future<NetworkResponse?> matchReservation(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    int sportId,
    DateTime date,
    int timeBegin,
    int timeEnd,
    double cost,
    Coupon? coupon,
    double finalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
    String cvv,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMatchReservation(
    BuildContext context,
    String accessToken,
    int idStoreCourt,
    int sportId,
    int weekday,
    List<DateTime> currentMonthDates,
    int timeBegin,
    int timeEnd,
    double cost,
    double totalCost,
    SelectedPayment selectedPayment,
    String cpf,
    int? idCreditCard,
    String cvv,
    bool isRenovating,
  ) async {
    return null;
  }

  Future<NetworkResponse?> recurrentMonthAvailableHours(
    BuildContext context,
    String accessToken,
    int weekday,
    int timeBegin,
    int timeEnd,
    int idStoreCourt,
    bool isRenovating,
  ) async {
    return null;
  }

  Future<NetworkResponse?> validateCoupon(
    BuildContext context,
    String couponCode,
    int idStore,
    int timeBegin,
    int timeEnd,
    DateTime date,
  ) async {
    return null;
  }
}
