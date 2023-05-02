import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandfriends/Onboarding/Repository/OnboardingRepoImp.dart';
import 'package:sandfriends/Onboarding/View/OnboardingScreenForm.dart';
import 'package:sandfriends/Onboarding/View/OnboardingScreenWelcome.dart';
import 'package:sandfriends/Onboarding/View/SportSelectorModal.dart';

import '../../SharedComponents/View/SFModalMessage.dart';
import '../../Utils/PageStatus.dart';
import '../../oldApp/models/city.dart';
import '../../SharedComponents/Model/Sport.dart';

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
  City? userCity;

  bool get isFormValid =>
      userSport != null &&
      userCity != null &&
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      phoneNumberController.text.isNotEmpty &&
      termsAgreeValue;

  void goToLoginSignup(BuildContext context) {
    context.goNamed('login_signup');
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

  void openSportSelectorModal() {
    widgetForm = SportSelectorModal(
        selectedSport: userSport,
        onClose: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        });
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }
}
