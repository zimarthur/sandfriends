import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/View/CvvModal.dart';
import 'package:sandfriends/Features/Checkout/View/PixModalResponse.dart';
import 'package:sandfriends/SharedComponents/Model/SelectedPayment.dart';
import 'package:sandfriends/Features/Checkout/Repository/CheckoutRepoImp.dart';
import 'package:sandfriends/Features/Checkout/View/Payment/ModalCreditCardSelector.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/SharedComponents/Model/Hour.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import 'package:sandfriends/Utils/Validators.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/Sport.dart';
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
  bool canTapBackground = true;

  late Court court;
  late List<HourPrice> hourPrices;
  late List<Hour> availableHours;
  late Sport sport;
  late DateTime date;
  late int weekday;
  late bool isRecurrent;
  late bool isRenovating;
  List<DateTime> matchDates = [];

  String cvv = "";

  SelectedPayment selectedPayment = SelectedPayment.NotSelected;
  CreditCard? selectedCreditCard;
  TextEditingController cpfController =
      MaskedTextController(mask: "000.000.000-00");
  TextEditingController cvvController = MaskedTextController(mask: "0000");

  final ScrollController scrollController = ScrollController();
  final FocusNode cpfFocus = FocusNode();

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

  int get totalPrice {
    return matchDates.length * matchPrice;
  }

  void initCheckoutScreen(
    BuildContext context,
    Court receivedCourt,
    List<HourPrice> receivedHourPrices,
    Sport receivedSport,
    DateTime? receivedDate,
    int? receivedWeekday,
    bool receivedIsRecurrent,
    bool receivedIsRenovating,
  ) {
    if (Provider.of<UserProvider>(context, listen: false).user!.cpf != null) {
      cpfController.text =
          Provider.of<UserProvider>(context, listen: false).user!.cpf!;
    }

    availableHours =
        Provider.of<CategoriesProvider>(context, listen: false).hours;
    court = receivedCourt;
    hourPrices = receivedHourPrices;
    sport = receivedSport;

    isRecurrent = receivedIsRecurrent;
    isRenovating = receivedIsRenovating;
    if (isRecurrent) {
      weekday = receivedWeekday!;
      checkoutRepo
          .recurrentMonthAvailableHours(
        context,
        Provider.of<UserProvider>(context, listen: false).user!.accessToken,
        weekday,
        startingHour.hour,
        endingHour.hour,
        court.idStoreCourt,
        isRenovating,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );

          final responseRecurrentDays =
              responseBody['RecurrentMonthAvailableHours'];
          for (var day in responseRecurrentDays) {
            matchDates.add(DateFormat('dd/MM/yyyy').parse(day));
          }

          pageStatus = PageStatus.OK;
          notifyListeners();
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              } else {
                pageStatus = PageStatus.OK;
                notifyListeners();
              }
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      date = receivedDate!;
      matchDates.add(date);
      pageStatus = PageStatus.OK;
      notifyListeners();
    }
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
      String? validationCpf = cpfValidator(cpfController.text, null);
      if (selectedPayment == SelectedPayment.Pix && validationCpf != null) {
        modalMessage = SFModalMessage(
            message:
                validationCpf[0].toUpperCase() + validationCpf.substring(1),
            onTap: () {
              pageStatus = PageStatus.OK;

              FocusScope.of(context).requestFocus(cpfFocus);

              notifyListeners();
            },
            isHappy: true);
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      } else if (selectedPayment == SelectedPayment.CreditCard) {
        widgetForm = CvvModal(
            selectedCreditCard: selectedCreditCard!,
            onCvv: (receivedCvv) {
              cvv = receivedCvv;
              makeReservation(context);
            });
        pageStatus = PageStatus.FORM;
        notifyListeners();
      } else {
        makeReservation(context);
      }
    } else {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt,
      sport.idSport,
      date,
      startingHour.hour,
      endingHour.hour,
      matchPrice,
      selectedPayment,
      cpfController.text.replaceAll(
        RegExp('[^0-9]'),
        '',
      ),
      selectedPayment == SelectedPayment.CreditCard
          ? selectedCreditCard!.idCreditCard
          : null,
      cvv,
    )
        .then((response) {
      if (selectedPayment == SelectedPayment.Pix &&
          response.responseStatus == NetworkResponseStatus.alert) {
        pixModalResponse(context, response.userMessage!);
      } else {
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
        canTapBackground = false;
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void recurrentMatchReservation(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    checkoutRepo
        .recurrentMatchReservation(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt,
      sport.idSport,
      weekday,
      matchDates,
      startingHour.hour,
      endingHour.hour,
      matchPrice,
      totalPrice,
      selectedPayment,
      cpfController.text.replaceAll(RegExp('[^0-9]'), ''),
      selectedPayment == SelectedPayment.CreditCard
          ? selectedCreditCard!.idCreditCard
          : null,
      cvv,
      isRenovating,
    )
        .then((response) {
      canTapBackground = false;
      if (selectedPayment == SelectedPayment.Pix &&
          response.responseStatus == NetworkResponseStatus.alert) {
        pixModalResponse(context, response.userMessage!);
      } else {
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
      }
    });
  }

  void pixModalResponse(BuildContext context, String response) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );

    widgetForm = PixModalResponse(
      message: responseBody["Message"],
      pixCode: responseBody["Pixcode"],
      isRecurrent: isRecurrent,
      onReturn: () => Navigator.pushNamed(context, '/home'),
    );
    pageStatus = PageStatus.FORM;
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
