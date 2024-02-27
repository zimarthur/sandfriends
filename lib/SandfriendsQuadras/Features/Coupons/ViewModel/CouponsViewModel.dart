import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../Common/Components/DatePickerModal.dart';
import '../../../../Common/Enum/EnumCouponStatus.dart';
import '../../../../Common/Enum/EnumPeriodVisualization.dart';
import '../../../../Common/Model/Coupon/CouponStore.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/StoreProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../Model/CouponsDataSource.dart';
import '../Model/CouponsTableCallback.dart';
import '../Model/EnumOrderByCoupon.dart';
import '../Repository/CouponsRepo.dart';
import '../View/Web/AddCouponModal.dart';

class CouponsViewModel extends ChangeNotifier {
  final couponsRepo = CouponsRepo();

  TextEditingController nameFilterController = TextEditingController();

  String defaultGender = "Todos gêneros";
  String defaultSport = "Todos esportes";

  late String filteredGender;
  late String filteredSport;

  List<String> genderFilters = [];
  List<String> sportsFilters = [];

  final List<CouponStore> _coupons = [];
  List<CouponStore> get coupons {
    List<CouponStore> filteredCoupons = _coupons;
    if (showOnlyActiveCoupons) {
      filteredCoupons =
          filteredCoupons.where((coupon) => coupon.isValidToday).toList();
    }
    switch (couponOrderBy) {
      case EnumOrderByCoupon.DateAscending:
        filteredCoupons.sort((a, b) => a.endingDate.compareTo(b.endingDate));
        break;
      case EnumOrderByCoupon.DateDescending:
        filteredCoupons.sort((a, b) => b.endingDate.compareTo(a.endingDate));
        break;
      case EnumOrderByCoupon.MostUsed:
        filteredCoupons.sort((a, b) => b.timesUsed.compareTo(a.timesUsed));
        break;
    }

    return filteredCoupons;
  }

  int get currentCoupons => coupons
      .where((coupon) => coupon.couponStatus == EnumCouponStatus.Valid)
      .length;

  CouponsDataSource? couponsDataSource;

  void initViewModel(BuildContext context) {
    setCouponsDataSource(context);
    notifyListeners();
  }

  List<EnumOrderByCoupon> availableCouponOrderBy = orderByCouponOptions;
  EnumOrderByCoupon couponOrderBy = EnumOrderByCoupon.DateDescending;
  void setCouponOrderBy(BuildContext context, String newOrder) {
    couponOrderBy = availableCouponOrderBy
        .firstWhere((element) => element.text == newOrder);
    setCouponsDataSource(context);
    notifyListeners();
  }

  void setCouponsDataSource(BuildContext context) {
    _coupons.clear();
    Provider.of<StoreProvider>(context, listen: false)
        .coupons
        .forEach((coupon) {
      _coupons.add(coupon);
    });
    couponsDataSource = CouponsDataSource(
      coupons: coupons,
      tableCallback: (callback, coupon, context) {
        if (callback == CouponsTableCallback.Disable) {
          enableDisableCoupon(context, coupon, true);
        } else if (callback == CouponsTableCallback.Enable) {
          enableDisableCoupon(context, coupon, false);
        }
      },
      context: context,
    );
    notifyListeners();
  }

  EnumPeriodVisualization periodVisualization =
      EnumPeriodVisualization.CurrentMonth;
  void setPeriodVisualization(
      BuildContext context, EnumPeriodVisualization newPeriodVisualization) {
    if (newPeriodVisualization == EnumPeriodVisualization.Custom) {
      setCustomPeriod(context);
    } else {
      periodVisualization = newPeriodVisualization;
      // setFinancesDataSource();
      notifyListeners();
    }
  }

  DateTime? customStartDate;
  DateTime? customEndDate;
  String? get customDateTitle {
    if (customStartDate != null) {
      if (customEndDate == null) {
        return DateFormat("dd/MM/yy").format(customStartDate!);
      } else {
        return "${DateFormat("dd/MM/yy").format(customStartDate!)} - ${DateFormat("dd/MM/yy").format(customEndDate!)}";
      }
    }
    return null;
  }

  void setCustomPeriod(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false)
        .setModalForm(DatePickerModal(
      onDateSelected: (dateStart, dateEnd) {
        customStartDate = dateStart;
        customEndDate = dateEnd;
        //searchCustomMatches(context);
      },
      onReturn: () =>
          Provider.of<MenuProvider>(context, listen: false).closeModal(),
    ));
  }

  bool editMode = false;
  void toggleEdit() {
    editMode = !editMode;
    notifyListeners();
  }

  bool showOnlyActiveCoupons = false;
  void toggleShowOnlyActiveCoupons(BuildContext context) {
    showOnlyActiveCoupons = !showOnlyActiveCoupons;
    setCouponsDataSource(context);
    notifyListeners();
  }

  void enableDisableCoupon(
    BuildContext context,
    CouponStore coupon,
    bool disable,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    couponsRepo
        .enableDisableCoupon(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      coupon,
      disable,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<StoreProvider>(context, listen: false)
            .setCoupons(context, responseBody);
        setCouponsDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Cupom atualizado!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void closeModal(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  void openAddCouponModal(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      AddCouponModal(
        onReturn: () => closeModal(context),
        onCreateCoupon: (coupon) => addCoupon(context, coupon),
      ),
    );
  }

  void addCoupon(BuildContext context, CouponStore coupon) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    couponsRepo
        .addCoupon(
            context,
            Provider.of<StoreProvider>(context, listen: false)
                .loggedAccessToken,
            coupon)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<StoreProvider>(context, listen: false)
            .setCoupons(context, responseBody);
        setCouponsDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Cupom adicionado!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }
}
