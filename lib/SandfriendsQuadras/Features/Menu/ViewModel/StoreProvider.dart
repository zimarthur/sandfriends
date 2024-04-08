import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LocalStorage/LocalStorageManager.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/Infrastructure.dart';
import 'package:sandfriends/Common/Model/Classes/School/School.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchStore.dart';
import '../../../../Common/Model/Coupon/CouponStore.dart';
import '../../../../Common/Model/Court.dart';
import '../../../../Common/Model/Gender.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/HourPrice/HourPriceStore.dart';
import '../../../../Common/Model/SandfriendsQuadras/Reward.dart';
import '../../../../Common/Model/Rank.dart';
import '../../../../Common/Model/SandfriendsQuadras/AppNotificationStore.dart';
import '../../../../Common/Model/SandfriendsQuadras/AvailableSport.dart';
import '../../../../Common/Model/SandfriendsQuadras/Employee.dart';
import '../../../../Common/Model/SandfriendsQuadras/StoreWorkingHours.dart';
import '../../../../Common/Model/Classes/School/SchoolStore.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Model/Store/StoreComplete.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';

class StoreProvider extends ChangeNotifier {
  StoreComplete? _store;
  StoreComplete? get store => _store;
  set store(StoreComplete? value) {
    _store = value;
    notifyListeners();
  }

  void clearStoreProvider() {
    _employees.clear();
    _store = null;
    courts.clear();
    notifications.clear();
    allMatches.clear();
    rewards.clear();
    recurrentMatches.clear();
  }

  List<StoreWorkingDay>? get storeWorkingDays {
    if (courts.isEmpty) {
      return null;
    }
    List<StoreWorkingDay> storeWorkingDays = [];
    for (var opDay in courts.first.operationDays) {
      var storeWorkingDay = StoreWorkingDay(
        weekday: opDay.weekday,
        isEnabled: opDay.prices.isNotEmpty,
      );
      if (storeWorkingDay.isEnabled) {
        storeWorkingDay.startingHour = opDay.prices
            .reduce((a, b) => a.startingHour.hour < b.startingHour.hour ? a : b)
            .startingHour;
        storeWorkingDay.endingHour = opDay.prices
            .reduce((a, b) => a.endingHour.hour > b.endingHour.hour ? a : b)
            .endingHour;
      }
      storeWorkingDays.add(
        storeWorkingDay,
      );
    }
    return storeWorkingDays;
  }

  List<Court> courts = [];

  List<AppNotificationStore> notifications = [];

  List<AppMatchStore> allMatches = [];
  List<AppMatchStore> get matches =>
      allMatches.where((match) => match.canceled == false).toList();
  late DateTime matchesStartDate;
  late DateTime matchesEndDate;

  List<AppRecurrentMatchStore> recurrentMatches = [];

  List<Reward> rewards = [];

  List<CouponStore> coupons = [];

  List<UserStore> storePlayers = [];

  List<SchoolStore> schools = [];
  void addSchool(SchoolStore newSchool) {
    schools.add(newSchool);
    notifyListeners();
  }

  void updateSchool(SchoolStore editedSchool) {
    schools.removeWhere((element) => element.idSchool == editedSchool.idSchool);
    schools.add(editedSchool);
    notifyListeners();
    // for (var school in schools) {
    //   if (school.idSchool == editedSchool.idSchool) {
    //     school = School.copyFrom(editedSchool);
    //     notifyListeners();
    //     break;
    //   }
    // }
    for (var school in schools) {
      print("AAAAA ${school.idSchool} ${school.teachers.length}");
    }
  }

  final List<Employee> _employees = [];
  List<Employee> get employees {
    _employees.sort((a, b) {
      if (a.admin && b.admin) {
        return a.registrationDate!.compareTo(b.registrationDate!);
      } else if (a.admin) {
        return -1;
      } else if (b.admin) {
        return 1;
      } else {
        if (a.registrationDate != null && b.registrationDate != null) {
          return a.registrationDate!.compareTo(b.registrationDate!);
        } else if (a.registrationDate != null) {
          return -1;
        } else if (b.registrationDate != null) {
          return 1;
        } else {
          return 0;
        }
      }
    });
    return _employees;
  }

  void setEmployeesFromResponse(BuildContext context, String body) {
    Map<String, dynamic> responseBody = json.decode(
      body,
    );
    _employees.clear();
    for (var employee in responseBody["Employees"]) {
      _employees.add(
        Employee.fromJson(
          employee,
        ),
      );
    }
    _employees
        .firstWhere((employee) => employee.email == loggedEmail)
        .isLoggedUser = true;
    notifyListeners();
  }

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  Employee get loggedEmployee {
    return employees.firstWhere((employee) => employee.isLoggedUser);
  }

  bool isLoggedEmployeeAdmin() {
    return loggedEmployee.admin;
  }

  String loggedEmail = "";

  void setLoginResponse(
    BuildContext context,
    String response,
    bool keepConnected,
  ) {
    clearStoreProvider();
    Map<String, dynamic> responseBody = json.decode(
      response,
    );
    Provider.of<EnvironmentProvider>(context, listen: false)
        .setAccessToken(responseBody["AccessToken"]);
    loggedEmail = responseBody["LoggedEmail"];
    if (keepConnected) {
      LocalStorageManager()
          .storeAccessToken(context, responseBody['AccessToken']);
    }

    for (var employee in responseBody['Store']['Employees']) {
      _employees.add(Employee.fromJson(employee));
    }
    _employees
        .firstWhere((employee) => employee.email == loggedEmail)
        .isLoggedUser = true;

    Provider.of<CategoriesProvider>(context, listen: false)
        .setCategoriesProvider(responseBody);

    for (var notification in responseBody['Notifications']) {
      notifications.add(
        AppNotificationStore.fromJson(
          notification,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        ),
      );
    }

    setLastNotificationId(context);

    setSchoolsResponse(context, responseBody);
    setPlayersResponse(context, responseBody);

    store = StoreComplete.fromJson(responseBody['Store']);

    setCourts(context, responseBody);
    setStoreInfrastructures(context, responseBody);
    setMatches(context, responseBody);
    setRecurrentMatches(context, responseBody);
    setRewards(responseBody);
    setCoupons(context, responseBody);

    matchesStartDate =
        DateFormat("dd/MM/yyyy").parse(responseBody['MatchesStartDate']);
    matchesEndDate =
        DateFormat("dd/MM/yyyy").parse(responseBody['MatchesEndDate']);

    notifyListeners();
  }

  void setSchoolsResponse(
      BuildContext context, Map<String, dynamic> responseBody) {
    schools.clear();
    for (var school in responseBody['Store']['StoreSchools']) {
      schools.add(SchoolStore.fromJson(
        school,
        Provider.of<CategoriesProvider>(context, listen: false).hours,
        Provider.of<CategoriesProvider>(context, listen: false).sports,
        Provider.of<CategoriesProvider>(context, listen: false).ranks,
        Provider.of<CategoriesProvider>(context, listen: false).genders,
      ));
    }
  }

  void setPlayersResponse(
      BuildContext context, Map<String, dynamic> responseBody) {
    storePlayers.clear();
    for (var storePlayer in responseBody['StorePlayers']) {
      storePlayers.add(UserStore.fromStorePlayerJson(
        storePlayer,
        Provider.of<CategoriesProvider>(context, listen: false).sports,
        Provider.of<CategoriesProvider>(context, listen: false).genders,
        Provider.of<CategoriesProvider>(context, listen: false).ranks,
      ));
    }

    for (var matchMember in responseBody['MatchMembers']) {
      storePlayers.add(UserStore.fromUserJson(
        matchMember,
        Provider.of<CategoriesProvider>(context, listen: false).sports,
        Provider.of<CategoriesProvider>(context, listen: false).genders,
        Provider.of<CategoriesProvider>(context, listen: false).ranks,
      ));
    }
  }

  void setCourts(BuildContext context, Map<String, dynamic> responseBody) {
    courts.clear();
    for (var court in responseBody['Courts']) {
      var newCourt = Court.fromJson(court);
      for (var sport
          in Provider.of<CategoriesProvider>(context, listen: false).sports) {
        bool foundSport = false;
        for (var courtSport in court["Sports"]) {
          if (courtSport["IdSport"] == sport.idSport) {
            foundSport = true;
          }
        }
        newCourt.sports
            .add(AvailableSport(sport: sport, isAvailable: foundSport));
      }

      for (var courtPrices in court["Prices"]) {
        newCourt.operationDays
            .firstWhere((opDay) => opDay.weekday == courtPrices["Day"])
            .prices
            .add(
              HourPriceStore(
                startingHour: Provider.of<CategoriesProvider>(context,
                        listen: false)
                    .hours
                    .firstWhere(
                        (hour) => hour.hour == courtPrices["IdAvailableHour"]),
                price: courtPrices["Price"],
                recurrentPrice: courtPrices["RecurrentPrice"],
                priceTeacher: courtPrices["PriceTeacher"],
                recurrentPriceTeacher: courtPrices["RecurrentPriceTeacher"],
                endingHour: Provider.of<CategoriesProvider>(context,
                        listen: false)
                    .hours
                    .firstWhere(
                        (hour) => hour.hour > courtPrices["IdAvailableHour"]),
              ),
            );
      }

      courts.add(newCourt);
    }
  }

  void setStoreInfrastructures(
      BuildContext context, Map<String, dynamic> responseBody) {
    store?.infrastructures.clear();
    List<int> infrastructureIds = [];
    for (var infrastructure in responseBody['Store']['StoreInfrastructures']) {
      infrastructureIds.add(infrastructure["IdInfrastructureCategory"]);
    }

    for (var infrastrucutre
        in Provider.of<CategoriesProvider>(context, listen: false)
            .infrastructures) {
      store?.infrastructures.add(
        Infrastructure.copyFrom(
          infrastrucutre,
          isSelected: infrastructureIds.contains(infrastrucutre.id),
        ),
      );
    }
  }

  void setMatches(BuildContext context, Map<String, dynamic> responseBody) {
    allMatches.clear();
    for (var match in responseBody['Matches']) {
      allMatches.add(
        AppMatchStore.fromJson(
          match,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        ),
      );
    }
  }

  void setRecurrentMatches(
      BuildContext context, Map<String, dynamic> responseBody) {
    recurrentMatches.clear();
    for (var recurrentMatch in responseBody['RecurrentMatches']) {
      recurrentMatches.add(
        AppRecurrentMatchStore.fromJson(
          recurrentMatch,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        ),
      );
    }
  }

  void setRewards(Map<String, dynamic> responseBody) {
    rewards.clear();
    for (var reward in responseBody['Rewards']) {
      rewards.add(
        Reward.fromJson(reward),
      );
    }
  }

  void setCoupons(BuildContext context, Map<String, dynamic> responseBody) {
    coupons.clear();
    for (var coupon in responseBody['Coupons']) {
      coupons.add(
        CouponStore.fromJson(
          coupon,
          Provider.of<CategoriesProvider>(context, listen: false).hours,
        ),
      );
    }
  }

  bool _hasUnseenNotifications = false;
  bool get hasUnseenNotifications => _hasUnseenNotifications;
  set hasUnseenNotifications(bool value) {
    _hasUnseenNotifications = value;
    notifyListeners();
  }

  void setLastNotificationId(BuildContext context) async {
    int newLastNotificationId = notifications.isEmpty
        ? 0
        : notifications
            .reduce((a, b) => a.idNotification > b.idNotification ? a : b)
            .idNotification;
    int? lastNotificationId =
        await LocalStorageManager().getLastNotificationId(context);
    if (lastNotificationId != null) {
      if (lastNotificationId < newLastNotificationId) {
        hasUnseenNotifications = true;
      }
    }
    LocalStorageManager()
        .storeLastNotificationId(context, newLastNotificationId);
  }

  void setAllowNotificationsSetttings(bool allowNotifications) {
    employees
        .firstWhere((employee) => employee.isLoggedUser)
        .allowNotifications = allowNotifications;
    notifyListeners();
  }
}
