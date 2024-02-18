import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumDiscountType.dart';
import '../../../../Common/Model/Coupon/CouponStore.dart';
import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';
import 'package:intl/intl.dart';

class CouponsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> enableDisableCoupon(
    BuildContext context,
    String accessToken,
    CouponStore coupon,
    bool disable,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.enableDisableCoupon,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "IdCoupon": coupon.idCoupon,
          "Disable": disable,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> addCoupon(
    BuildContext context,
    String accessToken,
    CouponStore coupon,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.addCoupon,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "Code": coupon.couponCode,
          "Value": coupon.value,
          "DiscountType": coupon.discountType.text,
          "DateBegin": DateFormat("dd/MM/yyyy").format(
            coupon.startingDate!,
          ),
          "DateEnd": DateFormat("dd/MM/yyyy").format(
            coupon.endingDate!,
          ),
          "IdTimeBegin": coupon.hourBegin!.hour,
          "IdTimeEnd": coupon.hourEnd!.hour,
        },
      ),
    );
    return response;
  }
}
