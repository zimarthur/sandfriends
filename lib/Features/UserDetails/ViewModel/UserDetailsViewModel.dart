import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/Gender.dart';
import '../../../SharedComponents/Model/Rank.dart';
import '../../../SharedComponents/Model/Region.dart';
import '../../../SharedComponents/Model/SidePreference.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/User.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/CitySelectorModal.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/SFDateTime.dart';
import '../Repository/UserDetailsRepoImp.dart';
import '../View/Modal/UserDetailsModalAge.dart';
import '../View/Modal/UserDetailsModalGender.dart';
import '../View/Modal/UserDetailsModalHeight.dart';
import '../View/Modal/UserDetailsModalName.dart';
import '../View/Modal/UserDetailsModalPhoto.dart';
import '../View/Modal/UserDetailsModalRank.dart';
import '../View/Modal/UserDetailsModalSidePreference.dart';

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
  String? imagePicker;
  bool noImage = false;

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
        changedRank ||
        imagePicker != null ||
        (userReference.photo != null && noImage);
  }

  final userDetailsNameFormKey = GlobalKey<FormState>();
  final userDetailsAgeFormKey = GlobalKey<FormState>();
  final userDetailsHeightFormKey = GlobalKey<FormState>();
  final userDetailsPhoneNumberFormKey = GlobalKey<FormState>();

  void initUserDetailsViewModel(BuildContext context) {
    userEdited = User.copyWith(
      Provider.of<UserProvider>(context, listen: false).user!,
    );
    userReference = User.copyWith(
      Provider.of<UserProvider>(context, listen: false).user!,
    );
    displayedSport = userEdited.preferenceSport!;
    firstNameController.text = userEdited.firstName!;
    lastNameController.text = userEdited.lastName!;
    phoneNumberController.text = userEdited.phoneNumber!;
    birthdayController.text = userEdited.birthday.toString();
    heightController.text = userEdited.height.toString();

    if (Provider.of<UserProvider>(context, listen: false).user!.ranks.isEmpty) {
      setDefaultRanks(context);
    }
  }

  void setDefaultRanks(BuildContext context) {
    Provider.of<CategoriesProvider>(context, listen: false)
        .ranks
        .forEach((rank) {
      if (rank.rankSportLevel == 0) {
        userEdited.ranks.add(rank);
        userReference.ranks.add(rank);
      }
    });
  }

  void changedDisplayedSport(BuildContext context, String? newValue) {
    displayedSport = Provider.of<CategoriesProvider>(context, listen: false)
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

  Future<void> updateUserInfo(BuildContext context) async {
    if (isEdited) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      if (noImage) {
        userEdited.photo = null;
      } else if (imagePicker != null) {
        File imageFile = File(imagePicker!);
        Uint8List bytes = imageFile.readAsBytesSync();
        userEdited.photo = base64Encode(bytes);
      }
      userDetailsRepo.updateUserInfo(userEdited).then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          User serverUser = User.fromJson(responseBody);
          serverUser.matchCounter = userReference.matchCounter;
          Provider.of<UserProvider>(context, listen: false).user = serverUser;
          userReference = User.copyWith(serverUser);
          userEdited = User.copyWith(serverUser);
          modalMessage = SFModalMessage(
            message: "Suas informações foram alteradas",
            onTap: () {
              pageStatus = PageStatus.OK;
              notifyListeners();
              imagePicker = null;
            },
            isHappy: true,
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        } else {
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
        }
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
        if (Provider.of<CategoriesProvider>(context, listen: false)
            .regions
            .isEmpty) {
          getAllCities(context);
        } else {
          modalForm = CitySelectorModal(
            regions:
                Provider.of<CategoriesProvider>(context, listen: false).regions,
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
    Provider.of<CategoriesProvider>(context, listen: false)
        .categoriesProviderRepo
        .getAllCities()
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .setRegions(response.responseBody!);

        modalForm = CitySelectorModal(
          regions:
              Provider.of<CategoriesProvider>(context, listen: false).regions,
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
