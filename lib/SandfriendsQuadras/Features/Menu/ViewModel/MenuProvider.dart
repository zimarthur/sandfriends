import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/ClassesScreenWeb.dart';
import '../../../../Common/Components/Modal/SFModalConfirmation.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Utils/Responsive.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Authentication/Login/Repository/LoginRepo.dart';
import '../../Coupons/View/Mobile/CouponsScreenMobile.dart';
import '../../Coupons/View/Web/CouponsScreenWeb.dart';
import '../../Help/View/HelpScreen.dart';
import '../../Home/View/Web/HomeScreenWeb.dart';
import '../../Home/View/Mobile/HomeScreenMobile.dart';
import '../../MyCourts/View/Web/MyCourtsScreenWeb.dart';
import '../../MyCourts/View/Mobile/MyCourtsScreenMobile.dart';
import '../../Finances/View/Web/FinancesScreenWeb.dart';
import '../../Finances/View/Mobile/FinancesScreenMobile.dart';
import '../../Calendar/View/Web/CalendarScreenWeb.dart';
import '../../Calendar/View/Mobile/CalendarScreenMobile.dart';
import '../../Players/View/Web/PlayersScreenWeb.dart';
import '../../Players/View/Mobile/PlayersScreenMobile.dart';
import '../../Rewards/View/Web/RewardsScreenWeb.dart';
import '../../Rewards/View/Mobile/RewardsScreenMobile.dart';
import '../../Settings/View/Web/SettingsScreenWeb.dart';
import '../../Settings/View/Mobile/SettingsScreenMobile.dart';
import '../Model/DrawerItem.dart';
import 'StoreProvider.dart';

class MenuProvider extends StandardScreenViewModel {
  final loginRepo = LoginRepo();

  @override
  void onTapReturn(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .setPageStatusOk();
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .clearOverlays();
    quickLinkHome(context);
  }

  void initHomeScreen(BuildContext context) {
    validateAuthentication(context);
  }

  bool _isEmployeeAdmin = false;
  bool get isEmployeeAdmin => _isEmployeeAdmin;
  void setIsEmployeeAdmin(bool newValue) {
    _isEmployeeAdmin = newValue;
    notifyListeners();
  }

  void validateAuthentication(BuildContext context) async {
    if (Provider.of<StoreProvider>(context, listen: false).store == null) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      String? storedToken = await LocalStorageManager().getAccessToken(context);
      if (storedToken != null) {
        loginRepo.validateToken(context, storedToken).then((response) async {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
          if (response.responseStatus == NetworkResponseStatus.success) {
            try {
              Provider.of<StoreProvider>(context, listen: false)
                  .setLoginResponse(context, response.responseBody!, true);
            } catch (e) {
              print(e);
            }
            setIsEmployeeAdmin(
                Provider.of<StoreProvider>(context, listen: false)
                    .isLoggedEmployeeAdmin());
            setSelectedDrawerItem(mainDrawer.first);
            String? lastPage = await LocalStorageManager().getLastPage(context);
            if (lastPage != null &&
                permissionsDrawerItems
                    .any((drawer) => drawer.title == lastPage)) {
              onTabClick(
                  permissionsDrawerItems
                      .firstWhere((drawer) => drawer.title == lastPage),
                  context);
            } else {
              Navigator.pushNamed(context, '/home');
            }
          } else {
            Navigator.pushNamed(context, "/login");
          }
        });
      } else {
        Navigator.pushNamed(context, "/login");
      }
    } else {
      setIsEmployeeAdmin(Provider.of<StoreProvider>(context, listen: false)
          .isLoggedEmployeeAdmin());
      setSelectedDrawerItem(mainDrawer.first);
    }
  }

  Future<void> updateStoreProvider(BuildContext context) async {
    String? storedToken = await LocalStorageManager().getAccessToken(context);
    if (storedToken != null) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      NetworkResponse response =
          await loginRepo.validateToken(context, storedToken);
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setLoginResponse(context, response.responseBody!, true);
        setIsEmployeeAdmin(Provider.of<StoreProvider>(context, listen: false)
            .isLoggedEmployeeAdmin());
        setSelectedDrawerItem(mainDrawer.first);
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    }
  }

  void setMessageModalFromResponse(
      BuildContext context, NetworkResponse response,
      {VoidCallback? onTap}) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addModalMessage(
      SFModalMessage(
        title: response.responseTitle!,
        description: response.responseDescription,
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      ),
    );
  }

  void setModalConfirmation(BuildContext context, String title,
      String description, VoidCallback onContinue, VoidCallback onReturn,
      {bool? isConfirmationPositive}) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      SFModalConfirmation(
        title: title,
        description: description,
        onContinue: onContinue,
        onReturn: onReturn,
        isConfirmationPositive: isConfirmationPositive,
      ),
    );
  }

  bool _isDrawerOpened = false;
  bool get isDrawerOpened => _isDrawerOpened;
  set isDrawerOpened(bool value) {
    _isDrawerOpened = value;
    notifyListeners();
  }

  bool _isDrawerExpanded = true;
  bool get isDrawerExpanded => _isDrawerExpanded;
  set isDrawerExpanded(bool value) {
    _isDrawerExpanded = value;
    notifyListeners();
  }

  String _hoveredDrawerTitle = "";
  String get hoveredDrawerTitle => _hoveredDrawerTitle;
  void setHoveredDrawerTitle(String newTitle) {
    _hoveredDrawerTitle = newTitle;
    notifyListeners();
  }

  double getScreenWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (Responsive.isMobile(context)) {
      width = width - 4 * defaultPadding;
    } else if ((Responsive.isDesktop(context) && isDrawerExpanded) ||
        isDrawerExpanded) {
      width = width - 250 - 4 * defaultPadding;
    } else {
      width = width - 82 - 4 * defaultPadding;
    }
    return width;
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - 2 * defaultPadding;
  }

  final List<DrawerItem> _drawerItems = [
    DrawerItem(
      title: "Início",
      icon: r"assets/icon/home.svg",
      requiresAdmin: false,
      widgetWeb: const HomeScreenWeb(),
      widgetMobile: const HomeScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Calendário",
      icon: r"assets/icon/calendar.svg",
      requiresAdmin: false,
      widgetWeb: const CalendarScreenWeb(),
      widgetMobile: const CalendarScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Recompensas",
      icon: r"assets/icon/star.svg",
      requiresAdmin: false,
      widgetWeb: RewardsScreenWeb(),
      widgetMobile: RewardsScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Financeiro",
      icon: r"assets/icon/payment.svg",
      requiresAdmin: true,
      widgetWeb: FinancesScreenWeb(),
      widgetMobile: FinancesScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Minhas quadras",
      icon: r"assets/icon/court.svg",
      requiresAdmin: false,
      widgetWeb: MyCourtsScreenWeb(),
      widgetMobile: MyCourtsScreenMobile(),
      mainDrawer: true,
    ),
    DrawerItem(
      title: "Aulas",
      icon: r"assets/icon/class.svg",
      requiresAdmin: false,
      widgetWeb: ClassesScreenWeb(),
      widgetMobile: PlayersScreenMobile(),
      mainDrawer: true,
      availableMobile: false,
    ),
    DrawerItem(
      title: "Jogadores",
      icon: r"assets/icon/user_group.svg",
      requiresAdmin: false,
      widgetWeb: PlayersScreenWeb(),
      widgetMobile: PlayersScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Cupons de desconto",
      icon: r"assets/icon/discount_filled.svg",
      requiresAdmin: true,
      widgetWeb: CouponsScreenWeb(),
      widgetMobile: CouponsScreenMobile(),
      mainDrawer: true,
      availableMobile: true,
    ),
    DrawerItem(
      title: "Meu perfil",
      icon: r"assets/icon/user.svg",
      requiresAdmin: false,
      widgetWeb: SettingsScreenWeb(),
      widgetMobile: SettingsScreenMobile(),
      mainDrawer: false,
    ),
    DrawerItem(
      title: "Ajuda",
      icon: r"assets/icon/help.svg",
      requiresAdmin: false,
      widgetWeb: HelpScreen(),
      widgetMobile: Container(),
      mainDrawer: false,
    ),
    DrawerItem(
      title: "Sair",
      icon: r"assets/icon/logout.svg",
      requiresAdmin: false,
      widgetWeb: Container(),
      widgetMobile: Container(),
      mainDrawer: false,
      color: Colors.red,
      logout: true,
    ),
  ];
  List<DrawerItem> get permissionsDrawerItems {
    if (isEmployeeAdmin) {
      return _drawerItems;
    } else {
      return _drawerItems
          .where((drawer) => drawer.requiresAdmin == false)
          .toList();
    }
  }

  List<DrawerItem> get mainDrawer {
    return permissionsDrawerItems.where((drawer) => drawer.mainDrawer).toList();
  }

  List<DrawerItem> get mobileDrawerItems =>
      mainDrawer.where((element) => element.availableMobile == true).toList();

  List<DrawerItem> get secondaryDrawer {
    return permissionsDrawerItems
        .where((drawer) => !drawer.mainDrawer)
        .toList();
  }

  DrawerItem _selectedDrawerItem = DrawerItem(
    title: "title",
    icon: "",
    requiresAdmin: false,
    mainDrawer: false,
    widgetMobile: Container(),
    widgetWeb: Container(),
  );
  DrawerItem get selectedDrawerItem => _selectedDrawerItem;
  void setSelectedDrawerItem(DrawerItem drawer) {
    _selectedDrawerItem = drawer;
    notifyListeners();
  }

  bool get isOnHome => selectedDrawerItem.title == "Início";

  void onTabClick(DrawerItem drawerItem, BuildContext context) {
    LocalStorageManager().storeLastPage(context, drawerItem.title);
    setSelectedDrawerItem(drawerItem);
    if (drawerItem.logout) {
      logout(context);
    }
    try {
      Scaffold.of(context).closeEndDrawer();
    } catch (e) {}
    notifyListeners();
  }

  void quickLinkHome(BuildContext context) {
    onTabClick(
      mainDrawer.firstWhere((element) => element.title == "Início"),
      context,
    );
  }

  void quickLinkSettingMobile(BuildContext context) {
    Navigator.of(context).pushNamed("/settings");
  }

  void quickLinkBrand(BuildContext context) {
    DrawerItem? drawer = permissionsDrawerItems
        .firstWhereOrNull((tab) => tab.title == "Meu perfil");

    if (drawer != null) {
      onTabClick(
        drawer,
        context,
      );
    }
  }

  void quickLinkWorkingHours(BuildContext context) {
    DrawerItem? drawer = permissionsDrawerItems
        .firstWhereOrNull((tab) => tab.title == "Minhas quadras");
    if (drawer != null) {
      onTabClick(
        drawer,
        context,
      );
    }
  }

  void quickLinkMyCourts(BuildContext context) {
    onTabClick(
      mainDrawer.firstWhere((element) => element.title == "Minhas quadras"),
      context,
    );
  }

  void logout(BuildContext context) {
    Provider.of<StoreProvider>(context, listen: false).clearStoreProvider();
    LocalStorageManager().storeAccessToken(context, "");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
