import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../../Common/Components/Modal/CitySelectorModal.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Model/User.dart';
import '../Repository/OnboardingRepo.dart';
import '../View/OnboardingScreenForm.dart';
import '../View/OnboardingScreenWelcome.dart';
import '../View/SportSelectorModal.dart';

class OnboardingViewModel extends StandardScreenViewModel {
  void initOnboardingViewModel(BuildContext context) {
    displayWidget = OnboardingWidgetWelcome(viewModel: this);
    firstNameController.text =
        Provider.of<UserProvider>(context, listen: false).user?.firstName ?? "";
    lastNameController.text =
        Provider.of<UserProvider>(context, listen: false).user?.lastName ?? "";
    if (Provider.of<UserProvider>(context, listen: false).user!.email.isEmpty) {
      isEmailEmpty = true;
    }
    notifyListeners();
  }

  final onboardingRepo = OnboardingRepo();

  late Widget displayWidget;

  final onboardingFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool termsAgreeValue = false;

  Sport? userSport;
  City? userCity;

  bool isEmailEmpty = false;

  bool get isFormValid =>
      userSport != null &&
      userCity != null &&
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      termsAgreeValue &&
      (!isEmailEmpty || emailController.text.isNotEmpty);

  void goToLoginSignup(BuildContext context) {
    Navigator.pushNamed(context, '/login_signup');
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
    FocusScope.of(context).unfocus();
    widgetForm = SportSelectorModal(
      sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
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
    FocusScope.of(context).unfocus();
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    if (Provider.of<CategoriesProvider>(context, listen: false)
        .regions
        .isEmpty) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .categoriesProviderRepo
          .getAllCities(context)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<CategoriesProvider>(context, listen: false)
              .setRegions(response.responseBody!);

          displayCitySelector(context);
        } else {
          modalMessage = SFModalMessage(
            title: response.responseTitle!,
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
      regions: Provider.of<CategoriesProvider>(context, listen: false).regions,
      onSelectedCity: (city) {
        userCity = city;
        pageStatus = PageStatus.OK;
        notifyListeners();
        FocusScope.of(context).unfocus();
      },
      onReturn: () => closeModal(),
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
          context,
          Provider.of<UserProvider>(context, listen: false).user!.accessToken,
          firstNameController.text,
          lastNameController.text,
          "",
          userCity!.cityId,
          userSport!.idSport,
          isEmailEmpty ? emailController.text : null,
        )
            .then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            Map<String, dynamic> responseBody = json.decode(
              response.responseBody!,
            );
            Provider.of<UserProvider>(context, listen: false).user =
                User.fromJson(responseBody['User']);
            Navigator.pushNamed(context, '/home');
          } else {
            modalMessage = SFModalMessage(
              title: response.responseTitle!,
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
