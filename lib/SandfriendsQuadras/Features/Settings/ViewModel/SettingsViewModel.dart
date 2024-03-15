import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Model/SandfriendsQuadras/StorePhoto.dart';
import '../../../../Common/Model/Store/StoreComplete.dart';
import '../../../../Common/Model/TabItem.dart';
import '../../../../Common/Utils/SFImage.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/StoreProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../BasicInfo/View/BasicInfo.dart';
import '../BrandInfo/View/BrandInfo.dart';
import '../EmployeeInfo/View/EmployeeInfo.dart';
import '../Repository/SettingsRepo.dart';

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

  late StoreComplete storeRef;
  late StoreComplete storeEdit;

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
    setIsEmployeeAdmin(Provider.of<StoreProvider>(context, listen: false)
        .isLoggedEmployeeAdmin());
    storeRef = StoreComplete.copyWith(
        Provider.of<StoreProvider>(context, listen: false).store!);
    storeEdit = StoreComplete.copyWith(
        Provider.of<StoreProvider>(context, listen: false).store!);
    nameController.text = storeEdit.name;
    telephoneController.text = storeEdit.phoneNumber;
    telephoneOwnerController.text = storeEdit.ownerPhoneNumber ?? "";
    cepController.text = storeEdit.cep;
    neighbourhoodController.text = storeEdit.neighbourhood;
    addressController.text = storeEdit.address;
    addressNumberController.text = storeEdit.addressNumber;
    cityController.text = storeEdit.city.name;
    stateController.text = storeEdit.city.state!.uf;
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
      storeRef.city.state!.uf != storeEdit.city.state!.uf ||
      storeRef.neighbourhood != storeEdit.neighbourhood ||
      storeRef.description != storeEdit.description ||
      storeRef.instagram != storeEdit.instagram ||
      storeRef.cnpj != storeEdit.cnpj ||
      storeAvatar != null ||
      hasChangedPhoto;

  void updateUser(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    if (storeAvatar != null) {
      storeEdit.logo = base64Encode(storeAvatar!);
    }

    settingsRepo
        .updateStoreInfo(context, storeEdit, storeAvatar != null)
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<StoreProvider>(context, listen: false).store =
            StoreComplete.fromJson(
          responseBody["Store"],
        );
        initSettingsViewModel(context);
        hasChangedPhoto = false;
        storeAvatar = null;
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Seus dados foram atualizados!",
            onTap: () {},
            isHappy: true,
          ),
        );
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          context,
          response,
        );
      }
    });
  }

  Future setStoreAvatar(BuildContext context) async {
    final image = await selectImage(context, 1);

    if (image != null) {
      storeAvatar = image;
      notifyListeners();
    }
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();
  }

  Future addStorePhoto(BuildContext context) async {
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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .removeLastOverlay();
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
    storeEdit.phoneNumber = newValue.getRawNumber();
    notifyListeners();
  }

  void onChangedOwnerPhoneNumber(String newValue) {
    storeEdit.ownerPhoneNumber = newValue.getRawNumber();
    notifyListeners();
  }

  void onChangedCep(String newValue) {
    storeEdit.cep = newValue.getRawNumber();
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
    storeEdit.city.state!.uf = newValue;
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
    storeEdit.cnpj = newValue.getRawNumber();
    notifyListeners();
  }

  void updateAllowNotifications(BuildContext context, bool allow) async {
    String token = "";
    if (allow) {
      token = await FirebaseMessaging.instance.getToken() ?? "";
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      print("Token is: $token");
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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    settingsRepo
        .allowNotifications(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      allow,
      token,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<StoreProvider>(context, listen: false)
            .setAllowNotificationsSetttings(responseBody["AllowNotifications"]);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .removeLastOverlay();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          context,
          response,
        );
      }
    });
  }

  void deleteAccount(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
      context,
      "Deseja mesmo deletar sua conta?",
      "Você não conseguirá mais fazer acesso a plataforma se deletar sua conta.",
      isConfirmationPositive: false,
      () {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setLoading();
        settingsRepo
            .deleteAccount(
          context,
          Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
        )
            .then((response) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
          if (response.responseStatus == NetworkResponseStatus.success) {
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .addModalMessage(
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
              context,
              response,
            );
          }
        });
      },
      () => Provider.of<StandardScreenViewModel>(context, listen: false)
          .removeLastOverlay(),
    );
  }
}
