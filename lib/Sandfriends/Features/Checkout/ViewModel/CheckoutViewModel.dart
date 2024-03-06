import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Coupon/CouponUser.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/AddCupomModal.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/CvvModal.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/PixModalResponse.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/Repository/CheckoutRepo.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Payment/ModalCreditCardSelector.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/Hour.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/View/NewCreditCardModal.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Model/CouponUnited.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Model/HourPrice/HourPriceUser.dart';

class CheckoutViewModel extends ChangeNotifier {
  final checkoutRepo = CheckoutRepo();

  late Court court;
  late List<HourPriceUser> hourPrices;
  late List<Hour> availableHours;
  late Sport sport;
  late DateTime date;
  late int weekday;
  late bool isRecurrent;
  late bool isRenovating;
  List<DateTime> matchDates = [];

  CouponUser? appliedCoupon;

  String cvv = "";

  SelectedPayment selectedPayment = SelectedPayment.NotSelected;
  CreditCard? selectedCreditCard;
  TextEditingController cpfController = MaskedTextController(
    mask: "000.000.000-00",
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController cvvController = MaskedTextController(mask: "0000");
  TextEditingController cupomController = TextEditingController();

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

  double get matchPrice {
    return hourPrices.fold(
        0, (previousValue, element) => previousValue + element.price);
  }

  double get finalMatchPrice {
    double discount = 0.0;
    if (appliedCoupon != null) {
      discount = appliedCoupon!.calculateDiscount(totalPrice);
    }
    return totalPrice - discount;
  }

  double get totalPrice {
    return matchDates.length * matchPrice;
  }

  void initCheckoutScreen(
    BuildContext context,
    Court receivedCourt,
    List<HourPriceUser> receivedHourPrices,
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
        court.idStoreCourt!,
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
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .setPageStatusOk();
          });
        } else {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addModalMessage(
            SFModalMessage(
              title: response.responseTitle!,
              onTap: () {
                if (response.responseStatus ==
                    NetworkResponseStatus.expiredToken) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login_signup',
                    (Route<dynamic> route) => false,
                  );
                }
              },
              isHappy: response.responseStatus == NetworkResponseStatus.alert,
            ),
          );
        }
      });
    } else {
      date = receivedDate!;
      matchDates.add(date);
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      notifyListeners();
    }
  }

  void setNewSelectedPayment(
      BuildContext context, SelectedPayment newSelectedPayment) {
    if (newSelectedPayment == selectedPayment) {
      selectedPayment = SelectedPayment.NotSelected;
    } else if (newSelectedPayment == SelectedPayment.CreditCard) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addOverlayWidget(
        ModalCreditCardSelector(
          onSelectedCreditCard: (selectedCreditCard) =>
              onSelectedCreditCard(context, selectedCreditCard),
          onAddNewCreditCard: () {
            {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addOverlayWidget(
                NewCreditCardModal(),
              );
            }
          },
        ),
      );
    } else {
      selectedPayment = newSelectedPayment;
      if (newSelectedPayment == SelectedPayment.PayInStore) {
        appliedCoupon = null;
      }
    }
    notifyListeners();
  }

  void onSelectedCreditCard(
      BuildContext context, CreditCard newSelectedCreditCard) {
    selectedCreditCard = newSelectedCreditCard;
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .clearOverlays();
    selectedPayment = SelectedPayment.CreditCard;
    notifyListeners();
  }

  void validateReservation(BuildContext context) {
    if (selectedPayment != SelectedPayment.NotSelected) {
      String? validationCpf = cpfValidator(cpfController.text, null);
      if (selectedPayment == SelectedPayment.Pix && validationCpf != null) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: validationCpf[0].toUpperCase() + validationCpf.substring(1),
            onTap: () {
              FocusScope.of(context).requestFocus(cpfFocus);
            },
            isHappy: true,
          ),
        );
      } else if (selectedPayment == SelectedPayment.CreditCard) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          CvvModal(
            selectedCreditCard: selectedCreditCard!,
            onCvv: (receivedCvv) {
              cvv = receivedCvv;
              makeReservation(context);
            },
          ),
        );
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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    checkoutRepo
        .matchReservation(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt!,
      sport.idSport,
      date,
      startingHour.hour,
      endingHour.hour,
      matchPrice,
      appliedCoupon,
      finalMatchPrice,
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
          response.responseStatus == NetworkResponseStatus.success) {
        pixModalResponse(context, response.responseBody!);
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .clearOverlays();
              if (response.responseStatus == NetworkResponseStatus.alert) {
                Navigator.pushNamed(context, '/home');
              }
            },
            buttonText: response.responseStatus == NetworkResponseStatus.alert
                ? "Concluído"
                : "Voltar",
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
    });
  }

  void recurrentMatchReservation(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    checkoutRepo
        .recurrentMatchReservation(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      court.idStoreCourt!,
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
      if (selectedPayment == SelectedPayment.Pix &&
          response.responseStatus == NetworkResponseStatus.success) {
        pixModalResponse(context, response.responseBody!);
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .clearOverlays();
              if (response.responseStatus == NetworkResponseStatus.alert) {
                Navigator.pushNamed(context, '/home');
              }
            },
            buttonText: response.responseStatus == NetworkResponseStatus.alert
                ? "Concluído"
                : "Voltar",
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
    });
  }

  void pixModalResponse(BuildContext context, String response) {
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      PixModalResponse(
        message: responseBody["Message"],
        pixCode: responseBody["Pixcode"],
        isRecurrent: isRecurrent,
        onReturn: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .clearOverlays();
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }

  void onAddCupom(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      AddCupomModal(
        cupomController: cupomController,
        onAddCupom: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
            ..setLoading();
          checkoutRepo
              .validateCoupon(
                  context,
                  cupomController.text,
                  court.store!.idStore,
                  startingHour.hour,
                  endingHour.hour,
                  date)
              .then((response) {
            if (response.responseStatus == NetworkResponseStatus.success) {
              Map<String, dynamic> responseBody = json.decode(
                response.responseBody!,
              );
              appliedCoupon = CouponUser.fromJson(responseBody);
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .setPageStatusOk();
              notifyListeners();
            } else {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .addModalMessage(
                SFModalMessage(
                  title: response.responseTitle!,
                  onTap: () {
                    onAddCupom(context);
                  },
                  isHappy:
                      response.responseStatus == NetworkResponseStatus.alert,
                ),
              );
            }
          });
        },
        onReturn: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
        },
      ),
    );
  }
}
