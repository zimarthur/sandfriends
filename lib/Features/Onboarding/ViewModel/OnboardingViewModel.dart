import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Onboarding/Repository/OnboardingRepoImp.dart';
import 'package:sandfriends/Features/Onboarding/View/CitySelectorModal.dart';
import 'package:sandfriends/Features/Onboarding/View/OnboardingScreenForm.dart';
import 'package:sandfriends/Features/Onboarding/View/OnboardingScreenWelcome.dart';
import 'package:sandfriends/Features/Onboarding/View/SportSelectorModal.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/SharedPreferences.dart';
import 'package:sandfriends/Utils/validators.dart';
import 'package:sandfriends/SharedComponents/Model/Region.dart';

import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/User.dart';

class OnboardingViewModel extends ChangeNotifier {
  void initOnboardingViewModel() {
    displayWidget = OnboardingWidgetWelcome(viewModel: this);
    notifyListeners();
  }

  final onboardingRepo = OnboardingRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;

  String titleTextWelcome = "Boas-vindas";
  String titleTextForm = "Meu perfil";
  late Widget displayWidget;

  final onboardingFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(000) 00000-00000');
  bool termsAgreeValue = false;

  Sport? userSport;
  Region? userRegion;

  bool get isFormValid =>
      userSport != null &&
      userRegion != null &&
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      phoneNumberController.text.isNotEmpty &&
      termsAgreeValue;

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void goToOnboardingForm(BuildContext context) {
    displayWidget = OnboardingWidgetForm(viewModel: this);
    notifyListeners();
  }

  void goToOnboardingWelcome(BuildContext context) {
    displayWidget = OnboardingWidgetWelcome(viewModel: this);
    notifyListeners();
  }

  void openSportSelectorModal(BuildContext context) {
    widgetForm = SportSelectorModal(
      sports: Provider.of<DataProvider>(context, listen: false).sports,
      selectedSport: userSport,
      onSelectedSport: (newSport) {
        userSport = newSport;
        pageStatus = PageStatus.OK;
        notifyListeners();
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void openCitySelectorModal(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    if (Provider.of<DataProvider>(context, listen: false).regions.isEmpty) {
      onboardingRepo.getAllCities().then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          for (var state in responseBody['States']) {
            Provider.of<DataProvider>(context, listen: false).regions.add(
                  Region.fromJson(
                    state,
                  ),
                );
          }

          displayCitySelector(context);
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage!,
            onTap: () => openCitySelectorModal(context),
            isHappy: false,
            buttonText: "Tentar novamente",
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      displayCitySelector(context);
    }
  }

  void displayCitySelector(BuildContext context) {
    widgetForm = CitySelectorModal(
      regions: Provider.of<DataProvider>(context, listen: false).regions,
      onSelectedCity: (region) {
        userRegion = region;
        pageStatus = PageStatus.OK;
        notifyListeners();
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  addUserInfo(BuildContext context) {
    if (isFormValid) {
      if (onboardingFormKey.currentState?.validate() == true) {
        pageStatus = PageStatus.LOADING;
        notifyListeners();
        onboardingRepo
            .addUserInfo(
          Provider.of<DataProvider>(context, listen: false).user!.accessToken,
          firstNameController.text,
          lastNameController.text,
          phonenumberConverter(phoneNumberController.text),
          userRegion!.selectedCity!.cityId,
          userSport!.idSport,
        )
            .then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            Map<String, dynamic> responseBody = json.decode(
              response.responseBody!,
            );
            Provider.of<DataProvider>(context, listen: false).user =
                User.fromJson(responseBody['User']);
            Navigator.pushNamed(context, '/home');
          } else {
            modalMessage = SFModalMessage(
              message: response.userMessage.toString(),
              onTap: () {
                pageStatus = PageStatus.OK;
                notifyListeners();
              },
              isHappy: false,
            );
            pageStatus = PageStatus.ERROR;
            notifyListeners();
          }
        });
      }
    }
  }
}
