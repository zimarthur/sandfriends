import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Enum/EnumCouponStatus.dart';
import 'package:sandfriends/Common/Model/Coupon/CouponStore.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Common/Model/CouponUnited.dart';
import '../../../../Common/Utils/Constants.dart';
import 'CouponsTableCallback.dart';

class CouponsDataSource extends DataGridSource {
  CouponsDataSource({
    required List<CouponStore> coupons,
    required Function(CouponsTableCallback, CouponStore, BuildContext)
        tableCallback,
    required BuildContext context,
  }) {
    _coupons = coupons
        .map<DataGridRow>(
          (coupon) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'couponCode',
                value: coupon.couponCode,
              ),
              DataGridCell<String>(
                columnName: 'couponValue',
                value: coupon.valueText,
              ),
              DataGridCell<Text>(
                columnName: 'validDates',
                value: Text(
                  "${DateFormat("dd/MM/yy").format(
                    coupon.startingDate!,
                  )} - ${DateFormat("dd/MM/yy").format(
                    coupon.endingDate!,
                  )}",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              DataGridCell<String>(
                columnName: 'validHour',
                value:
                    "${coupon.hourBegin!.hourString} - ${coupon.hourEnd!.hourString}",
              ),
              DataGridCell<Widget>(
                columnName: "status",
                value: couponStatus(
                  coupon,
                ),
              ),
              DataGridCell<String>(
                columnName: 'timesUsed',
                value: coupon.timesUsed.toString(),
              ),
              DataGridCell<Text>(
                columnName: 'profit',
                value: Text(
                  coupon.profit!.formatPrice(),
                  style: TextStyle(
                    color: coupon.profit! > 0 ? greenText : null,
                    fontWeight: coupon.profit! > 0 ? FontWeight.bold : null,
                  ),
                ),
              ),
              DataGridCell<Widget>(
                columnName: 'actions',
                value: action(coupon, tableCallback, context),
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _coupons = [];

  @override
  List<DataGridRow> get rows => _coupons;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 48,
              child: dataGridCell.value is Widget
                  ? dataGridCell.value
                  : Text(
                      dataGridCell.value.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: divider,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget couponStatus(CouponStore coupon) {
    return Container(
      decoration: BoxDecoration(
        color: coupon.couponStatus!.textBg,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding / 2,
        horizontal: defaultPadding,
      ),
      child: Text(
        coupon.couponStatus!.text,
        style: TextStyle(
          color: coupon.couponStatus!.textColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget action(
    CouponStore coupon,
    Function(CouponsTableCallback, CouponStore, BuildContext) callback,
    BuildContext context,
  ) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      icon: SvgPicture.asset(
        r'assets/icon/three_dots.svg',
        height: 14,
        color: textDarkGrey,
      ),
      tooltip: "",
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem> items = [];

        if (coupon.couponStatus == EnumCouponStatus.Valid ||
            coupon.couponStatus == EnumCouponStatus.Unavailable) {
          items.add(PopupMenuItem(
            value: CouponsTableCallback.Disable,
            child: Row(
              children: [
                SvgPicture.asset(
                  r"assets/icon/block.svg",
                  color: textDarkGrey,
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  'Dasabilitar',
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
              ],
            ),
          ));
        }
        if (!coupon.isValid! && coupon.canBeDisabled!) {
          items.add(
            PopupMenuItem(
              value: CouponsTableCallback.Enable,
              child: Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/check.svg",
                    color: textDarkGrey,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Text(
                    'Habilitar',
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return items;
      },
      elevation: 2,
      onSelected: (value) => callback(value, coupon, context),
    );
  }
}
