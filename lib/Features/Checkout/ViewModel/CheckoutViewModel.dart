import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepoImp.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/SharedComponents/Model/Hour.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';

import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../Court/Model/HourPrice.dart';

class CheckoutViewModel extends ChangeNotifier {
  final checkoutRepo = CheckoutRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );

  late Court court;
  late List<HourPrice> hourPrices;
  late List<Hour> availableHours;
  late Sport sport;
  late DateTime date;
  late bool isRecurrent;

  SelectedPayment selectedPayment = SelectedPayment.NotSelected;

  String get matchPeriod {
    Hour startHour =
        hourPrices.reduce((a, b) => a.hour.hour < b.hour.hour ? a : b).hour;
    Hour endHour = availableHours.firstWhere((hour) =>
        hour.hour ==
        1 +
            hourPrices
                .reduce((a, b) => a.hour.hour > b.hour.hour ? a : b)
                .hour
                .hour);

    return "${startHour.hourString} - ${endHour.hourString}";
  }

  int get matchPrice {
    return hourPrices.fold(
        0, (previousValue, element) => previousValue + element.price);
  }

  void initCheckoutScreen(
    BuildContext context,
    Court receivedCourt,
    List<HourPrice> receivedHourPrices,
    Sport receivedSport,
    DateTime receivedDate,
    bool receivedIsRecurrent,
  ) {
    availableHours =
        Provider.of<CategoriesProvider>(context, listen: false).hours;
    court = receivedCourt;
    hourPrices = receivedHourPrices;
    sport = receivedSport;
    date = receivedDate;
    isRecurrent = receivedIsRecurrent;
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void setNewSelectedPayment(SelectedPayment newSelectedPayment) {
    selectedPayment = newSelectedPayment;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
