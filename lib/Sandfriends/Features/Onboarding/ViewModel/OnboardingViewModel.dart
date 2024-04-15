import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/Model/User/UserStore.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Onboarding/Enum/EnumOnboardingPage.dart';

import '../../../../Common/Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../Providers/TeacherProvider/TeacherProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Model/Sport.dart';
import '../Repository/OnboardingRepo.dart';
import '../View/OnboardingWidgetForm.dart';
import '../View/OnboardingWidgetWelcome.dart';
import '../View/SportSelectorModal.dart';

class OnboardingViewModel extends ChangeNotifier {
  void initOnboardingViewModel(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .setPageStatusOk();
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

  void onTapReturn(BuildContext context) {
    if (onboardingPage == EnumOnboardingPage.Welcome) {
      Navigator.pushNamed(context, "/login_signup");
    } else {
      goToOnboardingWelcome(context);
    }
  }

  void openSportSelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      SportSelectorModal(
        sports: Provider.of<CategoriesProvider>(context, listen: false).sports,
        selectedSport: userSport,
        onSelectedSport: (newSport) {
          onSelectedSport(newSport);
          notifyListeners();
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
        },
      ),
    );
  }

  void onSelectedSport(Sport newSport) {
    userSport = newSport;
    notifyListeners();
  }

  void openCitySelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(CitySelectorModal(
      onlyAvailableCities: false,
      onSelectedCity: (city) {
        onSelectedCity(city);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .removeLastOverlay();
        FocusScope.of(context).unfocus();
      },
      onReturn: () =>
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay(),
    ));
  }

  void onSelectedCity(City newCity) {
    userCity = newCity;
    notifyListeners();
  }

  addUserInfo(BuildContext context) {
    if (isFormValid) {
      if (onboardingFormKey.currentState?.validate() == true) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setLoading();

        onboardingRepo
            .addUserInfo(
          context,
          Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
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
            if (Provider.of<EnvironmentProvider>(context, listen: false)
                .environment
                .isSandfriendsAulas) {
              Provider.of<TeacherProvider>(context, listen: false)
                  .teacher
                  .user = UserStore.fromUserComplete(
                Provider.of<UserProvider>(context, listen: false).user!,
              );
            }
            if (Provider.of<EnvironmentProvider>(context, listen: false)
                    .environment
                    .isSandfriends ||
                Provider.of<EnvironmentProvider>(context, listen: false)
                    .environment
                    .isSandfriendsAulas) {
              Navigator.pushNamed(context, '/home');
            } else {
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .setPageStatusOk();
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .clearOverlays();
            }
          } else {
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .addModalMessage(
              SFModalMessage(
                title: response.responseTitle!,
                onTap: () {},
                isHappy: false,
              ),
            );
          }
        });
      }
    }
  }
}
