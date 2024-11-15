import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/StoreSearch/Repository/StoreSearchRepo.dart';
import 'package:sandfriends/Common/Model/Store/StoreComplete.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../Common/Components/Modal/CitySelectorModal/CitySelectorModal.dart';
import '../../../../Common/Model/Store/StoreUser.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../../Common/Model/City.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../MatchSearchFilter/Model/CustomFilter.dart';

class StoreSearchViewModel extends ChangeNotifier {
  final storeSearchRepo = StoreSearchRepo();

  bool isRecurrent = false;
  String get titleText =>
      "Busca quadra - ${currentCustomFilter.sport.description}";

  late CustomFilter defaultCustomFilter;
  late CustomFilter currentCustomFilter;

  bool get customFilterHasChanged => defaultCustomFilter != currentCustomFilter;

  void initViewModel(
    BuildContext context,
    int sportId,
    bool newIsRecurrent,
  ) {
    isRecurrent = newIsRecurrent;
    defaultCustomFilter = CustomFilter(
        orderBy: OrderBy.price,
        sport: Provider.of<UserProvider>(context, listen: false)
            .user!
            .preferenceSport!);
    currentCustomFilter = CustomFilter.copyFrom(defaultCustomFilter);

    if (Provider.of<CategoriesProvider>(context, listen: false)
        .availableRegions
        .any(
          (region) => region.containsCity(
            Provider.of<UserProvider>(context, listen: false)
                .user!
                .city!
                .cityId,
          ),
        )) {
      selectedCity =
          Provider.of<UserProvider>(context, listen: false).user!.city;
    }
    Provider.of<UserProvider>(context, listen: false)
        .handlePositionPermission()
        .then((value) {
      if (value == true) {
        defaultCustomFilter.orderBy = OrderBy.distance;
        currentCustomFilter.orderBy = OrderBy.distance;
        notifyListeners();
      }
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  City? selectedCity;
  bool get canSearchMatch => selectedCity != null;
  bool hasUserSearched = false;

  final List<StoreUser> _stores = [];
  List<StoreUser> get stores {
    if (currentCustomFilter.orderBy == OrderBy.distance) {
      List<StoreUser> sortedStores = _stores;
      sortedStores.sort(
        (a, b) => a.distanceBetweenPlayer!.compareTo(b.distanceBetweenPlayer!),
      );

      return sortedStores;
    }
    return _stores;
  }

  void openCitySelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      CitySelectorModal(
        onlyAvailableCities: true,
        onSelectedCity: (city) {
          selectedCity = city;
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          notifyListeners();
        },
        userCity: Provider.of<UserProvider>(context, listen: false).user!.city,
        onReturn: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .removeLastOverlay(),
      ),
    );
  }

  void searchStores(BuildContext context) {
    if (canSearchMatch) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

      storeSearchRepo
          .searchStores(
              context, currentCustomFilter.sport.idSport, selectedCity!.cityId)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          hasUserSearched = true;
          final responseBody = json.decode(response.responseBody!);
          final responseStores = responseBody['Stores'];
          _stores.clear();
          for (var store in responseStores) {
            StoreUser newStore = StoreUser.fromJson(
              store,
            );

            if (Provider.of<UserProvider>(context, listen: false)
                    .userLocation !=
                null) {
              newStore.distanceBetweenPlayer = Geolocator.distanceBetween(
                Provider.of<UserProvider>(context, listen: false)
                    .userLocation!
                    .latitude,
                Provider.of<UserProvider>(context, listen: false)
                    .userLocation!
                    .longitude,
                newStore.latitude,
                newStore.longitude,
              );
            }
            _stores.add(
              newStore,
            );
          }

          Provider.of<StandardScreenViewModel>(context, listen: false)
              .setPageStatusOk();
          notifyListeners();
        } else if (response.responseStatus ==
            NetworkResponseStatus.expiredToken) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .addModalMessage(
            SFModalMessage(
              title: response.responseTitle!,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              },
              isHappy: false,
            ),
          );
          //canTapBackground = false;
        }
      });
    } else {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Selecione uma cidade para buscar as quadras",
          onTap: () {},
          isHappy: true,
        ),
      );
    }
  }

  Future<void> goToSearchFilter(BuildContext context) async {
    Navigator.pushNamed(context, "/match_search_filter", arguments: {
      'defaultCustomFilter': defaultCustomFilter,
      'currentCustomFilter': currentCustomFilter,
      'selectedCityId': selectedCity,
      'hideOrderBy': true,
      'isRecurrent': isRecurrent,
    }).then((args) {
      final newFilter = (args as Map<String, CustomFilter>)['newFilter'];
      if (newFilter is CustomFilter) {
        bool needsUpdate = false;
        if (currentCustomFilter.sport.idSport != newFilter.sport.idSport) {
          needsUpdate = true;
        }
        currentCustomFilter = newFilter;
        if (needsUpdate) {
          searchStores(context);
        }
        notifyListeners();
      }
    });
  }

  void onTapStore(BuildContext context, StoreUser store) {
    Navigator.pushNamed(
      context,
      '/quadra/${store.url}',
      arguments: {
        'store': store,
        'canMakeReservation': true,
        'selectedSport': currentCustomFilter.sport,
        'isRecurrent': isRecurrent,
      },
    );
  }
}
