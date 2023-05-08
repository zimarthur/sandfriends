import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/UserDetails/Repository/UserDetailsRepoImp.dart';
import 'package:sandfriends/Features/UserDetails/View/Modal/UserDetailsModalGender.dart';
import 'package:sandfriends/Features/UserDetails/View/Modal/UserDetailsModalName.dart';
import 'package:sandfriends/Features/UserDetails/View/Modal/UserDetailsModalSidePreference.dart';
import 'package:sandfriends/SharedComponents/Model/Rank.dart';
import 'package:sandfriends/SharedComponents/Model/SidePreference.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/Gender.dart';
import '../../../SharedComponents/Model/Region.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/User.dart';
import '../../../SharedComponents/View/CitySelectorModal.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/SFDateTime.dart';
import '../View/Modal/UserDetailsModalAge.dart';
import '../View/Modal/UserDetailsModalHeight.dart';
import '../View/Modal/UserDetailsModalPhoto.dart';
import '../View/Modal/UserDetailsModalRank.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final userDetailsRepo = UserDetailsRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget modalForm = Container();

  String titleText = "Meu Perfil";

  late User userEdited;
  late User userReference;
  late Sport displayedSport;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(000) 00000-00000');
  final TextEditingController birthdayController =
      MaskedTextController(mask: '00/00/0000');
  final TextEditingController heightController =
      MaskedTextController(mask: '0,00');

  bool get isEdited {
    bool changedRank = false;
    for (var userEditedRank in userEdited.ranks) {
      if (userEditedRank.idRankCategory !=
          userReference.ranks
              .firstWhere((userRefRank) =>
                  userRefRank.sport.idSport == userEditedRank.sport.idSport)
              .idRankCategory) {
        changedRank = true;
      }
    }
    return userEdited.firstName != userReference.firstName ||
        userEdited.lastName != userReference.lastName ||
        userEdited.birthday != userReference.birthday ||
        userEdited.city != userReference.city ||
        userEdited.gender != userReference.gender ||
        userEdited.sidePreference != userReference.sidePreference ||
        userEdited.height != userReference.height ||
        userEdited.preferenceSport!.idSport !=
            userReference.preferenceSport!.idSport ||
        changedRank;
  }

  final userDetailsNameFormKey = GlobalKey<FormState>();
  final userDetailsAgeFormKey = GlobalKey<FormState>();
  final userDetailsHeightFormKey = GlobalKey<FormState>();
  final userDetailsPhoneNumberFormKey = GlobalKey<FormState>();

  void initUserDetailsViewModel(BuildContext context) {
    userEdited = User.copyWith(
      Provider.of<DataProvider>(context, listen: false).user!,
    );
    userReference = User.copyWith(
      Provider.of<DataProvider>(context, listen: false).user!,
    );
    displayedSport = userEdited.preferenceSport!;
    firstNameController.text = userEdited.firstName!;
    lastNameController.text = userEdited.lastName!;
    phoneNumberController.text = userEdited.phoneNumber!;
    birthdayController.text = userEdited.birthday.toString();
    heightController.text = userEdited.height.toString();

    if (Provider.of<DataProvider>(context, listen: false).user!.ranks.isEmpty) {
      setDefaultRanks(context);
    }
  }

  void setDefaultRanks(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false).ranks.forEach((rank) {
      if (rank.rankSportLevel == 0) {
        userEdited.ranks.add(rank);
        userReference.ranks.add(rank);
      }
    });
  }

  void changedDisplayedSport(BuildContext context, String? newValue) {
    displayedSport = Provider.of<DataProvider>(context, listen: false)
        .sports
        .firstWhere((sport) => sport.description == newValue);
    notifyListeners();
  }

  void setPreferenceSport() {
    userEdited.preferenceSport = displayedSport;
    notifyListeners();
  }

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void updateUserInfo(BuildContext context) {
    if (isEdited) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      userDetailsRepo.updateUserInfo(userEdited).then((response) {
        if (response.responseStatus == NetworkResponseStatus.alert) {
          Provider.of<DataProvider>(context, listen: false).user =
              User.copyWith(userEdited);
          userReference = User.copyWith(userEdited);
        }
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      });
    }
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }

  void setUserName() {
    if (userDetailsNameFormKey.currentState?.validate() == true) {
      userEdited.firstName = firstNameController.text;
      userEdited.lastName = lastNameController.text;
      pageStatus = PageStatus.OK;
      notifyListeners();
    }
  }

  void setUserAge() {
    if (userDetailsPhoneNumberFormKey.currentState?.validate() == true) {
      userEdited.birthday = stringToDateTime(birthdayController.text);
      pageStatus = PageStatus.OK;

      notifyListeners();
    }
  }

  void setUserHeight() {
    if (userDetailsPhoneNumberFormKey.currentState?.validate() == true) {
      userEdited.height =
          double.parse(heightController.text.replaceAll(",", "."));
      pageStatus = PageStatus.OK;

      notifyListeners();
    }
  }

  void setUserGender(Gender newGender) {
    userEdited.gender = newGender;
    pageStatus = PageStatus.OK;

    notifyListeners();
  }

  void setUserSidePreference(SidePreference newSidePreference) {
    userEdited.sidePreference = newSidePreference;
    pageStatus = PageStatus.OK;

    notifyListeners();
  }

  void openUserDetailsModal(UserDetailsModals modal, BuildContext context) {
    switch (modal) {
      case UserDetailsModals.Name:
        modalForm = UserDetailsModalName(
          viewModel: this,
        );
        break;
      case UserDetailsModals.Age:
        modalForm = UserDetailsModalAge(
          viewModel: this,
        );
        break;
      case UserDetailsModals.Height:
        modalForm = UserDetailsModalHeight(
          viewModel: this,
        );
        break;
      case UserDetailsModals.Rank:
        modalForm = UserDetailsModalRank(
          viewModel: this,
        );
        break;
      case UserDetailsModals.SidePreference:
        modalForm = UserDetailsModalSidePreference(
          viewModel: this,
        );
        break;
      case UserDetailsModals.Gender:
        modalForm = UserDetailsModalGender(
          viewModel: this,
        );
        break;
      case UserDetailsModals.Region:
        if (Provider.of<DataProvider>(context, listen: false).regions.isEmpty) {
          getAllCities(context);
        } else {
          modalForm = CitySelectorModal(
            regions: Provider.of<DataProvider>(context, listen: false).regions,
            onSelectedCity: (selectedCity) {
              userEdited.city = selectedCity;
              pageStatus = PageStatus.OK;
              notifyListeners();
            },
          );
          pageStatus = PageStatus.FORM;
          notifyListeners();
        }

        break;
      case UserDetailsModals.Photo:
        modalForm = UserDetailsModalPhoto(
          viewModel: this,
        );
        break;
    }
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void getAllCities(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    userDetailsRepo.getAllCities().then((response) {
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
        modalForm = CitySelectorModal(
          regions: Provider.of<DataProvider>(context, listen: false).regions,
          onSelectedCity: (selectedCity) {
            userEdited.city = selectedCity;
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
        );
        pageStatus = PageStatus.FORM;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
          onTap: () => getAllCities(context),
          isHappy: false,
          buttonText: "Tentar novamente",
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void setUserRank(Rank newRank) {
    userEdited.ranks
        .removeWhere((rank) => rank.sport.idSport == displayedSport.idSport);
    userEdited.ranks.add(newRank);
    pageStatus = PageStatus.OK;
    notifyListeners();
  }
}

enum UserDetailsModals {
  Name,
  Age,
  Height,
  Rank,
  Gender,
  Region,
  Photo,
  SidePreference,
}