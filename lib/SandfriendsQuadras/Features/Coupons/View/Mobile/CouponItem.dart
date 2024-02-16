import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Coupons/Model/CouponsTableCallback.dart';
import 'package:sandfriends_web/SharedComponents/Model/Coupon.dart';
import 'package:sandfriends_web/SharedComponents/Model/EnumCouponStatus.dart';
import 'package:sandfriends_web/SharedComponents/Model/Reward.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends_web/Utils/TypesExtensions.dart';
import '../../../../Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponItem extends StatelessWidget {
  Coupon coupon;
  bool editMode;
  VoidCallback onEnableCoupon;
  VoidCallback onDisableCoupon;
  CouponItem({
    required this.coupon,
    required this.editMode,
    required this.onDisableCoupon,
    required this.onEnableCoupon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            defaultPadding,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: coupon.couponStatus.textColor,
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                ),
                width: 6,
                height: 60,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          coupon.couponCode,
                          style: TextStyle(
                            color: textBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " | ${coupon.valueText}",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${coupon.hourDescription} | ${coupon.dateDescription} ",
                      style: TextStyle(
                        color: textLightGrey,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Column(
                children: [
                  Text(
                    "${coupon.timesUsed}X",
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                  Text(
                    coupon.profit.formatPrice(),
                    style: TextStyle(
                      color: greenText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (editMode && coupon.canBeDisabled)
                Switch(
                    value: coupon.isValid,
                    onChanged: (isValid) {
                      if (isValid) {
                        onEnableCoupon();
                      } else {
                        onDisableCoupon();
                      }
                    }),
            ],
          ),
        ),
        Container(
          height: 1,
          color: divider,
        ),
      ],
    );
  }
}
