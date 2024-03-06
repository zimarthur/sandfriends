import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/Enum/EnumOnboardingPage.dart';

import '../../../../Common/Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Model/Sport.dart';
import '../Repository/OnboardingRepo.dart';
import '../View/OnboardingWidgetForm.dart';
import '../View/OnboardingWidgetWelcome.dart';
import '../View/SportSelectorModal.dart';

class OnboardingViewModel extends StandardScreenViewModel {
  StandardScreenViewModel? parentViewModel;
  OnboardingViewModel({this.parentViewModel});

  void initOnboardingViewModel(BuildContext context) {
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

  EnumOnboardingPage onboardingPage = EnumOnboardingPage.Welcome;

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
    onboardingPage = EnumOnboardingPage.Information;
    notifyListeners();
  }

  void goToOnboardingWelcome(BuildContext context) {
    onboardingPage = EnumOnboardingPage.Welcome;
    notifyListeners();
  }

  @override
  void dispose() {
    print("DISPOSE VM");
    super.dispose();
  }

  void openSportSelectorModal(BuildContext context) {
    parentViewModel?.addOverlayWidget(
      SportSelectorModal(
        sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
        selectedSport: userSport,
        onSelectedSport: (newSport) {
          onSelectedSport(newSport);
          notifyListeners();
          parentViewModel?.removeLastOverlay();
        },
      ),
    );
  }

  void onSelectedSport(Sport newSport) {
    userSport = newSport;
    notifyListeners();
  }

  void openCitySelectorModal(BuildContext context) {
    parentViewModel?.addOverlayWidget(CitySelectorModal(
      onlyAvailableCities: false,
      onSelectedCity: (city) {
        onSelectedCity(city);
        parentViewModel?.removeLastOverlay();
        FocusScope.of(context).unfocus();
      },
      onReturn: () => parentViewModel?.removeLastOverlay(),
    ));
  }

  void onSelectedCity(City newCity) {
    userCity = newCity;
    notifyListeners();
  }

  addUserInfo(BuildContext context) {
    //parentViewModel?.clearOverlays();
    if (isFormValid) {
      if (onboardingFormKey.currentState?.validate() == true) {
        parentViewModel?.setLoading();
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
                UserComplete.fromJson(responseBody['User']);
            if (parentViewModel == null) {
              Navigator.pushNamed(context, '/home');
            } else {
              parentViewModel?.closeModal();
              parentViewModel?.clearOverlays();
            }
          } else {
            if (parentViewModel == null) {
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
            } else {
              parentViewModel?.setPageError(response.responseTitle!);
            }
          }
        });
      }
    }
  }
}
