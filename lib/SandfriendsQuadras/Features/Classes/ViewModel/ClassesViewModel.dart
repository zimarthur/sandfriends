import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/Repo/ClassesRepo.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/AddSchoolModal.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/AddTeacherModal.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/SchoolPanelModal.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/SchoolsWidget.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/ViewModel/StoreProvider.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Model/School/School.dart';
import '../../../../Common/Model/School/SchoolStore.dart';
import '../../../../Common/Model/TabItem.dart';
import '../../Menu/ViewModel/MenuProviderQuadras.dart';

class ClassesViewModel extends ChangeNotifier {
  final classesRepo = ClassesRepo();

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

  void initViewModel(BuildContext context) {
    tabItems.add(
      SFTabItem(
        name: "Escolas",
        displayWidget: SchoolsWidget(
          viewModel: this,
        ),
        onTap: (newTab) => setSelectedTab(newTab),
      ),
    );
    setSelectedTab(tabItems.first);
  }

  void openAddOrEditSchooolModal(BuildContext context, {School? school}) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      AddSchoolModal(
          school: school,
          onReturn: () =>
              Provider.of<StandardScreenViewModel>(context, listen: false)
                  .clearOverlays(),
          onAddOrEdit: (newSchool, schoolLogo) {
            if (school == null) {
              addNewSchool(context, newSchool, schoolLogo);
            } else {
              editSchool(context, newSchool, schoolLogo);
            }
          }),
    );
  }

  void addNewSchool(
      BuildContext context, School newSchool, Uint8List? schoolLogo) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    String? encodedLogo;
    if (schoolLogo != null) {
      encodedLogo = base64Encode(schoolLogo!);
    }

    classesRepo
        .addSchool(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      newSchool,
      encodedLogo,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<StoreProvider>(context, listen: false).addSchool(
          SchoolStore.fromJson(
            responseBody["NewSchool"],
            Provider.of<CategoriesProvider>(context, listen: false).sports,
          ),
        );
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .clearOverlays();
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Escola criada!",
            onTap: () {},
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
                Provider.of<MenuProviderQuadras>(context, listen: false)
                    .logout(context);
              }
            },
            isHappy: false,
          ),
        );
      }
    });
  }

  void editSchool(
      BuildContext context, School newSchool, Uint8List? schoolLogo) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

    String? encodedLogo;
    if (schoolLogo != null) {
      encodedLogo = base64Encode(schoolLogo!);
    }

    classesRepo
        .editSchool(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      newSchool,
      encodedLogo,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        SchoolStore editedSchool = SchoolStore.fromJson(
          responseBody["EditSchool"],
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        );

        Provider.of<StoreProvider>(context, listen: false)
            .updateSchool(editedSchool);
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .clearOverlays();
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Escola editada!",
            onTap: () {},
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
                Provider.of<MenuProviderQuadras>(context, listen: false)
                    .logout(context);
              }
            },
            isHappy: false,
          ),
        );
      }
    });
  }

  void onTapSchool(BuildContext context, School school) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      SchoolPanelModal(
        school: school,
        onReturn: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .clearOverlays(),
        onAddTeacher: () => onTapAddTeacher(
          context,
          school,
        ),
      ),
      showOnlyIfLast: false,
    );
  }

  void onTapAddTeacher(
    BuildContext context,
    School school,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      AddTeacherModal(
        onAdd: (email) => addTeacher(context, email, school),
        onReturn: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .removeLastOverlay(),
      ),
    );
  }

  void addTeacher(
    BuildContext context,
    String email,
    School school,
  ) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    classesRepo
        .addSchoolTeacher(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      school,
      email,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        SchoolStore editedSchool = SchoolStore.fromJson(
          responseBody["EditSchool"],
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        );

        Provider.of<StoreProvider>(context, listen: false)
            .updateSchool(editedSchool);

        Provider.of<StandardScreenViewModel>(context, listen: false)
            .removeLastOverlay();
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: "Professor adicionado!",
            onTap: () {},
            isHappy: true,
          ),
        );
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Provider.of<MenuProviderQuadras>(context, listen: false)
                    .logout(context);
              }
            },
            isHappy: false,
          ),
        );
      }
    });
  }

}
