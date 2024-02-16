import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Settings/BasicInfo/View/BasicInfo.dart';
import 'package:sandfriends_web/Features/Settings/BrandInfo/View/BrandInfo.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/View/EmployeeInfo.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/ViewModel/EmployeeInfoViewModel.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as IMG;
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sandfriends_web/Features/Settings/Repository/SettingsRepoImp.dart';
import 'package:sandfriends_web/SharedComponents/Model/StorePhoto.dart';
import 'package:sandfriends_web/Utils/Numbers.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/Model/TabItem.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Utils/SFImage.dart';
import '../../Menu/ViewModel/DataProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';

class SettingsViewModel extends ChangeNotifier {
  final settingsRepo = SettingsRepo();

  void initTabs() {
    tabItems.add(
      SFTabItem(
        name: "Dados básicos",
        displayWidget: BasicInfo(
          viewModel: this,
        ),
        onTap: (newTab) => setSelectedTab(newTab),
      ),
    );
    tabItems.add(
      SFTabItem(
        name: "Marca",
        displayWidget: BrandInfo(
          viewModel: this,
        ),
        onTap: (newTab) => setSelectedTab(newTab),
      ),
    );

    tabItems.add(
      SFTabItem(
        name: "Equipe",
        displayWidget: EmployeeInfo(),
        onTap: (newTab) => setSelectedTab(newTab),
      ),
    );
    setSelectedTab(tabItems.first);
  }

  List<SFTabItem> tabItems = [];

  SFTabItem _selectedTab =
      SFTabItem(name: "", displayWidget: Container(), onTap: (a) {});
  SFTabItem get selectedTab => _selectedTab;
  void setSelectedTab(SFTabItem newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }

  void setSelectedTabFromString(String tab) {
    _selectedTab = tabItems.firstWhere((tabItem) => tabItem.name == tab);
    notifyListeners();
  }

  late Store storeRef;
  late Store storeEdit;

  bool hasChangedPhoto = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController telephoneController = MaskedTextController(
    mask: '(00) 00000-0000',
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController cnpjController = MaskedTextController(
    mask: '00.000.000/0000-00',
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController cpfController = MaskedTextController(
    mask: '000.000.000-00',
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController cepController = MaskedTextController(
    mask: '00000-000',
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController neighbourhoodController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressNumberController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController telephoneOwnerController = MaskedTextController(
    mask: '(00) 00000-0000',
    cursorBehavior: CursorBehaviour.end,
  );
  TextEditingController descriptionController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();

  int get descriptionLength =>
      storeEdit.description == null ? 0 : storeEdit.description!.length;

  Uint8List? storeAvatarRef;

  Uint8List? _storeAvatar;
  Uint8List? get storeAvatar => _storeAvatar;
  set storeAvatar(Uint8List? newFile) {
    _storeAvatar = newFile;
    notifyListeners();
  }

  bool _isEmployeeAdmin = false;
  bool get isEmployeeAdmin => _isEmployeeAdmin;
  void setIsEmployeeAdmin(bool newValue) {
    _isEmployeeAdmin = newValue;
    notifyListeners();
  }

  void initSettingsViewModel(BuildContext context) {
    setIsEmployeeAdmin(Provider.of<DataProvider>(context, listen: false)
        .isLoggedEmployeeAdmin());
    storeRef = Store.copyWith(
        Provider.of<DataProvider>(context, listen: false).store!);
    storeEdit = Store.copyWith(
        Provider.of<DataProvider>(context, listen: false).store!);
    nameController.text = storeEdit.name;
    telephoneController.text = storeEdit.phoneNumber;
    telephoneOwnerController.text = storeEdit.ownerPhoneNumber ?? "";
    cepController.text = storeEdit.cep;
    neighbourhoodController.text = storeEdit.neighbourhood;
    addressController.text = storeEdit.address;
    addressNumberController.text = storeEdit.addressNumber;
    cityController.text = storeEdit.city.name;
    stateController.text = storeEdit.city.state.uf;
    descriptionController.text = storeEdit.description ?? "";
    instagramController.text = storeEdit.instagram ?? "";
    cnpjController.text = storeEdit.cnpj ?? "";
    if (tabItems.isEmpty) {
      initTabs();
    }
    notifyListeners();
  }

  bool get infoChanged =>
      storeRef.name != storeEdit.name ||
      storeRef.phoneNumber != storeEdit.phoneNumber ||
      storeRef.ownerPhoneNumber != storeEdit.ownerPhoneNumber ||
      storeRef.cep != storeEdit.cep ||
      storeRef.address != storeEdit.address ||
      storeRef.addressNumber != storeEdit.addressNumber ||
      storeRef.city.name != storeEdit.city.name ||
      storeRef.city.state.uf != storeEdit.city.state.uf ||
      storeRef.neighbourhood != storeEdit.neighbourhood ||
      storeRef.description != storeEdit.description ||
      storeRef.instagram != storeEdit.instagram ||
      storeRef.cnpj != storeEdit.cnpj ||
      storeAvatar != null ||
      hasChangedPhoto;

  void updateUser(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    if (storeAvatar != null) {
      storeEdit.logo = base64Encode(storeAvatar!);
    }

    settingsRepo
        .updateStoreInfo(context, storeEdit, storeAvatar != null)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<DataProvider>(context, listen: false).store =
            Store.fromJson(
          responseBody["Store"],
        );
        initSettingsViewModel(context);
        hasChangedPhoto = false;
        storeAvatar = null;
        Provider.of<MenuProvider>(context, listen: false).setMessageModal(
          "Seus dados foram atualizados!",
          null,
          true,
        );
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }

  Future setStoreAvatar(BuildContext context) async {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    final image = await selectImage(context, 1);

    if (image != null) {
      storeAvatar = image;
      notifyListeners();
    }

    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  Future addStorePhoto(BuildContext context) async {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    final image = await selectImage(context, 1.43);

    if (image != null) {
      storeEdit.photos.add(
        StorePhoto(
          idStorePhoto: storeEdit.photos.isEmpty
              ? 0
              : storeEdit.photos
                      .reduce((a, b) => a.idStorePhoto > b.idStorePhoto ? a : b)
                      .idStorePhoto +
                  1,
          photo: "",
          isNewPhoto: true,
          newPhoto: image,
        ),
      );
      hasChangedPhoto = true;
      notifyListeners();
    }

    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  void deleteStorePhoto(int idStorePhoto) {
    storeEdit.photos.removeWhere(
      (element) => element.idStorePhoto == idStorePhoto,
    );
    hasChangedPhoto = true;
    notifyListeners();
  }

  void onChangedName(String newValue) {
    storeEdit.name = newValue;
    notifyListeners();
  }

  void onChangedPhoneNumber(String newValue) {
    storeEdit.phoneNumber = getRawNumber(newValue);
    notifyListeners();
  }

  void onChangedOwnerPhoneNumber(String newValue) {
    storeEdit.ownerPhoneNumber = getRawNumber(newValue);
    notifyListeners();
  }

  void onChangedCep(String newValue) {
    storeEdit.cep = getRawNumber(newValue);
    notifyListeners();
  }

  void onChangedAddress(String newValue) {
    storeEdit.address = newValue;
    notifyListeners();
  }

  void onChangedAddressNumber(String newValue) {
    storeEdit.addressNumber = newValue;
    notifyListeners();
  }

  void onChangedNeighbourhood(String newValue) {
    storeEdit.neighbourhood = newValue;
    notifyListeners();
  }

  void onChangedCity(String newValue) {
    storeEdit.city.name = newValue;
    notifyListeners();
  }

  void onChangedState(String newValue) {
    storeEdit.city.state.uf = newValue;
    notifyListeners();
  }

  void onChangedDescription(String newValue) {
    storeEdit.description = newValue;
    notifyListeners();
  }

  void onChangedInstagram(String newValue) {
    storeEdit.instagram = newValue;
    notifyListeners();
  }

  void onChangedCnpj(String newValue) {
    storeEdit.cnpj = getRawNumber(newValue);
    notifyListeners();
  }

  void updateAllowNotifications(BuildContext context, bool allow) async {
    String token = "";
    if (allow) {
      token = await FirebaseMessaging.instance.getToken() ?? "";
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        allow = false;
      }
    }
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    settingsRepo
        .allowNotifications(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      allow,
      token,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<DataProvider>(context, listen: false)
            .setAllowNotificationsSetttings(responseBody["AllowNotifications"]);

        Provider.of<MenuProvider>(context, listen: false).closeModal();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }

  void deleteAccount(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
      "Deseja mesmo deletar sua conta?",
      "Você não conseguirá mais fazer acesso a plataforma se deletar sua conta.",
      isConfirmationPositive: false,
      () {
        Provider.of<MenuProvider>(context, listen: false).setModalLoading();
        settingsRepo
            .deleteAccount(
          context,
          Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
        )
            .then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            Provider.of<MenuProvider>(context, listen: false).setModalForm(
              SFModalMessage(
                title: "Sua conta foi deletada",
                onTap: () => Provider.of<MenuProvider>(context, listen: false)
                    .logout(context),
                isHappy: false,
              ),
            );
          } else if (response.responseStatus ==
              NetworkResponseStatus.expiredToken) {
            Provider.of<MenuProvider>(context, listen: false).logout(context);
          } else {
            Provider.of<MenuProvider>(context, listen: false)
                .setMessageModalFromResponse(
              response,
            );
          }
        });
      },
      () => Provider.of<MenuProvider>(context, listen: false).closeModal(),
    );
  }
}
