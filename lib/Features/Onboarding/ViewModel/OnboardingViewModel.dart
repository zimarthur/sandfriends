import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/CitySelectorModal.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/User.dart';
import '../../../Utils/Validators.dart';
import '../Repository/OnboardingRepoImp.dart';
import '../View/OnboardingScreenForm.dart';
import '../View/OnboardingScreenWelcome.dart';
import '../View/SportSelectorModal.dart';

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
      MaskedTextController(mask: '(00) 00000-00000');
  bool termsAgreeValue = false;

  Sport? userSport;
  City? userCity;

  bool get isFormValid =>
      userSport != null &&
      userCity != null &&
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
      regions: Provider.of<CategoriesProvider>(context, listen: false).regions,
      onSelectedCity: (city) {
        userCity = city;
        pageStatus = PageStatus.OK;
        notifyListeners();
        FocusScope.of(context).unfocus();
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
          context,
          Provider.of<UserProvider>(context, listen: false).user!.accessToken,
          firstNameController.text,
          lastNameController.text,
          phoneNumberController.text.replaceAll(RegExp('[^0-9]'), ''),
          userCity!.cityId,
          userSport!.idSport,
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
