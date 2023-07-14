import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepoImp.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/ModalCreditCardSelector.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/ModalCvv.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Model/Hour.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Utils/Validators.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
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
  Widget? widgetForm;

  late Court court;
  late List<HourPrice> hourPrices;
  late List<Hour> availableHours;
  late Sport sport;
  late DateTime date;
  late bool isRecurrent;

  SelectedPayment selectedPayment = SelectedPayment.NotSelected;
  CreditCard? selectedCreditCard;
  TextEditingController cpfController =
      MaskedTextController(mask: "000.000.000-00");
  TextEditingController cvvController = MaskedTextController(mask: "0000");

  final cvvFormKey = GlobalKey<FormState>();

  String get matchPeriod {
    return "${startingHour.hourString} - ${endingHour.hourString}";
  }

  Hour get startingHour {
    return hourPrices.reduce((a, b) => a.hour.hour < b.hour.hour ? a : b).hour;
  }

  Hour get endingHour {
    return availableHours.firstWhere(
      (hour) =>
          hour.hour ==
          1 +
              hourPrices
                  .reduce((a, b) => a.hour.hour > b.hour.hour ? a : b)
                  .hour
                  .hour,
    );
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
    if (newSelectedPayment == SelectedPayment.CreditCard) {
      widgetForm = ModalCreditCardSelector(
        onSelectedCreditCard: (selectedCreditCard) =>
            onSelectedCreditCard(selectedCreditCard),
      );
      pageStatus = PageStatus.FORM;
      selectedPayment = SelectedPayment.NotSelected;
    } else {
      selectedPayment = newSelectedPayment;
    }
    notifyListeners();
  }

  void onSelectedCreditCard(CreditCard newSelectedCreditCard) {
    selectedCreditCard = newSelectedCreditCard;
    pageStatus = PageStatus.OK;
    selectedPayment = SelectedPayment.CreditCard;
    notifyListeners();
  }

  void validateReservation(BuildContext context) {
    if (selectedPayment != SelectedPayment.NotSelected) {
      String? cvvValidator = cpfValidator(cpfController.text);
      if ((selectedPayment == SelectedPayment.CreditCard ||
              selectedPayment == SelectedPayment.Pix) &&
          cvvValidator != null) {
        modalMessage = SFModalMessage(
            message: cvvValidator,
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
            isHappy: true);
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      } else {
        if (selectedPayment == SelectedPayment.CreditCard) {
          widgetForm = ModalCvv();
          pageStatus = PageStatus.FORM;
          notifyListeners();
        } else {
          makeReservation(context);
        }
      }
    }
  }

  void makeReservation(BuildContext context) {
    if (isRecurrent) {
      recurrentMatchReservation(context);
    } else {
      matchReservation(context);
    }
  }

  void matchReservation(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    checkoutRepo
        .matchReservation(
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt,
      sport.idSport,
      date,
      startingHour.hour,
      endingHour.hour,
      matchPrice,
    )
        .then((response) {
      modalMessage = SFModalMessage(
        message: response.userMessage!,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            Navigator.pushNamed(context, '/home');
          } else {
            pageStatus = PageStatus.OK;
            notifyListeners();
          }
        },
        buttonText: response.responseStatus == NetworkResponseStatus.alert
            ? "Concluído"
            : "Voltar",
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void recurrentMatchReservation(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    checkoutRepo
        .recurrentMatchReservation(
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt,
      sport.idSport,
      0,
      startingHour.hour,
      endingHour.hour,
      matchPrice,
    )
        .then((response) {
      modalMessage = SFModalMessage(
        message: response.userMessage!,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            Navigator.pushNamed(context, '/home');
          } else {
            pageStatus = PageStatus.OK;
            notifyListeners();
          }
        },
        buttonText: response.responseStatus == NetworkResponseStatus.alert
            ? "Concluído"
            : "Voltar",
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }
}
