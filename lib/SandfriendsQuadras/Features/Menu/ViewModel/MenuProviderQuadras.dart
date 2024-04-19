import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:sandfriends/Common/Providers/Drawer/DrawerProvider.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDeviceAvailable.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/ClassesScreenWeb.dart';
import '../../../../Common/Components/Modal/SFModalConfirmation.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
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

class MenuProviderQuadras extends DrawerProvider {
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
    setDrawers(
      [
        DrawerItem(
          drawerPage: DrawerPage.Home,
          title: "Início",
          icon: r"assets/icon/home.svg",
          widgetWeb: const HomeScreenWeb(),
          widgetMobile: const HomeScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Calendar,
          title: "Calendário",
          icon: r"assets/icon/calendar.svg",
          widgetWeb: const CalendarScreenWeb(),
          widgetMobile: const CalendarScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Rewards,
          title: "Recompensas",
          icon: r"assets/icon/star.svg",
          widgetWeb: RewardsScreenWeb(),
          widgetMobile: RewardsScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Finances,
          title: "Financeiro",
          icon: r"assets/icon/price.svg",
          requiresAdmin: true,
          widgetWeb: FinancesScreenWeb(),
          widgetMobile: FinancesScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.MyCourts,
          title: "Minhas quadras",
          icon: r"assets/icon/court.svg",
          widgetWeb: MyCourtsScreenWeb(),
          widgetMobile: MyCourtsScreenMobile(),
          deviceAvailable: DeviceAvailable.Desktop,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Classes,
          title: "Aulas",
          icon: r"assets/icon/class.svg",
          widgetWeb: ClassesScreenWeb(),
          widgetMobile: PlayersScreenMobile(),
          deviceAvailable: DeviceAvailable.Desktop,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Players,
          title: "Jogadores",
          icon: r"assets/icon/user_group.svg",
          widgetWeb: PlayersScreenWeb(),
          widgetMobile: PlayersScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Discounts,
          title: "Cupons de desconto",
          icon: r"assets/icon/discount_filled.svg",
          requiresAdmin: true,
          widgetWeb: CouponsScreenWeb(),
          widgetMobile: CouponsScreenMobile(),
          deviceAvailable: DeviceAvailable.Both,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Profile,
          title: "Meu perfil",
          icon: r"assets/icon/user.svg",
          widgetWeb: SettingsScreenWeb(),
          widgetMobile: SettingsScreenMobile(),
          mainDrawer: false,
          deviceAvailable: DeviceAvailable.Desktop,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Help,
          title: "Ajuda",
          icon: r"assets/icon/help.svg",
          widgetWeb: HelpScreen(),
          widgetMobile: Container(),
          mainDrawer: false,
          deviceAvailable: DeviceAvailable.Desktop,
        ),
        DrawerItem(
          drawerPage: DrawerPage.Logout,
          title: "Sair",
          icon: r"assets/icon/logout.svg",
          widgetWeb: Container(),
          widgetMobile: Container(),
          mainDrawer: false,
          color: Colors.red,
          onTap: (context) => logout(context),
          deviceAvailable: DeviceAvailable.Both,
        ),
      ],
    );
    validateAuthentication(context);
  }

  void validateAuthentication(BuildContext context) async {
    if (Provider.of<StoreProvider>(context, listen: false).store == null) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      String? storedToken =
          Provider.of<EnvironmentProvider>(context, listen: false).accessToken;
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
            String? lastPage = await LocalStorageManager().getLastPage(context);
            if (lastPage != null &&
                permissionsDrawerItems.any(
                  (drawer) => drawer.title == lastPage,
                )) {
              onTabClick(
                  permissionsDrawerItems
                      .firstWhere((drawer) => drawer.title == lastPage)
                      .drawerPage,
                  context);
            } else {
              onTabClick(DrawerPage.Home, context);
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
      onTabClick(DrawerPage.Home, context);
    }
  }

  Future<void> updateStoreProvider(BuildContext context) async {
    String? storedToken =
        Provider.of<EnvironmentProvider>(context, listen: false).accessToken;
    if (storedToken != null) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      NetworkResponse response =
          await loginRepo.validateToken(context, storedToken);
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setLoginResponse(context, response.responseBody!, true);
        setIsEmployeeAdmin(Provider.of<StoreProvider>(context, listen: false)
            .isLoggedEmployeeAdmin());
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

  void quickLinkSettingMobile(BuildContext context) {
    Navigator.of(context).pushNamed("/settings");
  }

  void logout(BuildContext context) {
    Provider.of<StoreProvider>(context, listen: false).clearStoreProvider();
    Provider.of<EnvironmentProvider>(context, listen: false)
        .setAccessToken(null);
    LocalStorageManager().storeAccessToken(context, "");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
