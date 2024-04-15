import 'dart:convert';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import '../../../Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../Model/User/UserComplete.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Model/Gender.dart';
import '../../../Model/Rank.dart';
import '../../../Model/SidePreference.dart';
import '../../../Model/Sport.dart';
import '../../../Model/User/UserStore.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/Modal/SFModalMessage.dart';
import '../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/SFDateTime.dart';
import '../Repository/UserDetailsRepo.dart';
import '../View/Modal/UserDetailsModalAge.dart';
import '../View/Modal/UserDetailsModalGender.dart';
import '../View/Modal/UserDetailsModalHeight.dart';
import '../View/Modal/UserDetailsModalName.dart';
import '../View/Modal/UserDetailsModalPhoto.dart';
import '../View/Modal/UserDetailsModalRank.dart';
import '../View/Modal/UserDetailsModalSidePreference.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final userDetailsRepo = UserDetailsRepo();

  late UserComplete userEdited;
  late UserComplete userReference;
  late Sport displayedSport;
  late List<Rank> availableRanks;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = MaskedTextController(
    mask: '(00) 00000-00000',
    cursorBehavior: CursorBehaviour.end,
  );
  final TextEditingController birthdayController = MaskedTextController(
    mask: '00/00/0000',
    cursorBehavior: CursorBehaviour.end,
  );
  final TextEditingController heightController = MaskedTextController(
    mask: '0.00',
    cursorBehavior: CursorBehaviour.end,
  );
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
        userEdited.phoneNumber != userReference.phoneNumber ||
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

  final userDetailsPhoneNumberFormKey = GlobalKey<FormState>();

  void initUserDetailsViewModel(
      BuildContext context, Sport? initSport, UserDetailsModals initModal) {
    userEdited = UserComplete.copyWith(
      Provider.of<UserProvider>(context, listen: false).user!,
    );
    userReference = UserComplete.copyWith(
      Provider.of<UserProvider>(context, listen: false).user!,
    );
    availableRanks =
        Provider.of<CategoriesProvider>(context, listen: false).ranks;
    displayedSport = userEdited.preferenceSport!;
    firstNameController.text = userEdited.firstName!;
    lastNameController.text = userEdited.lastName!;
    phoneNumberController.text = userEdited.phoneNumber!;
    if (userEdited.birthday != null) {
      birthdayController.text =
          DateFormat('dd/MM/yyyy').format(userEdited.birthday!);
    }
    heightController.text = userEdited.height.toString();

    if (Provider.of<UserProvider>(context, listen: false).user!.ranks.isEmpty) {
      setDefaultRanks(context);
    }

    if (initSport != null) {
      displayedSport = initSport;
    } else {
      displayedSport = Provider.of<UserProvider>(context, listen: false)
          .user!
          .preferenceSport!;
    }
    if (initModal != UserDetailsModals.None) {
      openUserDetailsModal(initModal, context);
    }
  }

  List<Rank> get ranksForDisplayedSport {
    return availableRanks
        .where((rank) => rank.sport == displayedSport)
        .toList();
  }

  Rank get userRankForSport {
    return userEdited.ranks.firstWhere(
      (rank) => rank.sport.idSport == displayedSport.idSport,
    );
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

  void changedDisplayedSport(BuildContext context, Sport newSport) {
    displayedSport = newSport;
    notifyListeners();
  }

  void setPreferenceSport() {
    userEdited.preferenceSport = displayedSport;
    notifyListeners();
  }

  Future<void> updateUserInfo(BuildContext context) async {
    if (isEdited) {
      if (phoneNumberController.text.isNotEmpty &&
          userDetailsPhoneNumberFormKey.currentState?.validate() == false) {
        return;
      }
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

      if (noImage) {
        userEdited.photo = null;
      } else if (imagePicker != null) {
        File imageFile = File(imagePicker!);
        Uint8List bytes = imageFile.readAsBytesSync();
        userEdited.photo = base64Encode(bytes);
      }
      userDetailsRepo
          .updateUserInfo(
        context,
        userEdited,
        Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
      )
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          UserComplete serverUser = UserComplete.fromJson(responseBody);
          serverUser.matchCounter = userReference.matchCounter;
          Provider.of<UserProvider>(context, listen: false).user = serverUser;
          if (Provider.of<EnvironmentProvider>(context, listen: false)
              .environment
              .isSandfriendsAulas) {
            Provider.of<TeacherProvider>(context, listen: false).teacher.user =
                UserStore.fromUserComplete(serverUser);
          }
          userReference = UserComplete.copyWith(serverUser);
          userEdited = UserComplete.copyWith(serverUser);
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addModalMessage(
            SFModalMessage(
              title: "Suas informações foram alteradas",
              onTap: () {
                imagePicker = null;
                notifyListeners();
              },
              isHappy: true,
            ),
          );
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
          if (response.responseStatus == NetworkResponseStatus.expiredToken) {
            //canTapBackground = false;
          }
        }
      });
    }
  }

  void goToHome(BuildContext context) {
    Navigator.pop(context);
  }

  void setUserName(BuildContext context) {
    userEdited.firstName = firstNameController.text;
    userEdited.lastName = lastNameController.text;
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();
  }

  void setUserAge(BuildContext context) {
    if (birthdayController.text != "") {
      userEdited.birthday = stringToDateTime(birthdayController.text);
    }
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();
    notifyListeners();
  }

  void setUserHeight(BuildContext context) {
    if (heightController.text.isNotEmpty) {
      userEdited.height = double.parse(heightController.text);
    }
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();

    notifyListeners();
  }

  void setUserGender(BuildContext context, Gender newGender) {
    userEdited.gender = newGender;
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();

    notifyListeners();
  }

  void setUserSidePreference(
      BuildContext context, SidePreference newSidePreference) {
    userEdited.sidePreference = newSidePreference;
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();

    notifyListeners();
  }

  void setNoPhoto(bool newValue) {
    noImage = newValue;
    userEdited.photo = null;
    imagePicker = null;
    notifyListeners();
  }

  void openUserDetailsModal(UserDetailsModals modal, BuildContext context) {
    switch (modal) {
      case UserDetailsModals.Name:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalName(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.Age:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalAge(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.Height:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalHeight(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.Rank:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalRank(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.SidePreference:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalSidePreference(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.Gender:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalGender(
            viewModel: this,
          ),
        );
        break;
      case UserDetailsModals.Region:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          CitySelectorModal(
            onlyAvailableCities: false,
            onSelectedCity: (selectedCity) {
              userEdited.city = selectedCity;
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .removeLastOverlay();
              notifyListeners();
            },
            onReturn: () =>
                Provider.of<StandardScreenViewModel>(context, listen: false)
                    .removeLastOverlay(),
          ),
        );

        break;
      case UserDetailsModals.Photo:
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addOverlayWidget(
          UserDetailsModalPhoto(
            viewModel: this,
          ),
        );
        break;
      default:
        break;
    }
  }

  void updateUserPhoto(
      BuildContext context, bool newNoImage, String? newImagePicker) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .clearOverlays();
    noImage = newNoImage;
    imagePicker = newImagePicker;
    notifyListeners();
  }

  void setUserRank(BuildContext context, Rank newRank) {
    userEdited.ranks
        .removeWhere((rank) => rank.sport.idSport == displayedSport.idSport);
    userEdited.ranks.add(newRank);
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();
    notifyListeners();
  }

  void onChangedPhoneNumber(String newNumber) {
    userEdited.phoneNumber = newNumber;
    notifyListeners();
  }
}

enum UserDetailsModals {
  None,
  Name,
  Age,
  Height,
  Rank,
  Gender,
  Region,
  Photo,
  SidePreference,
}
