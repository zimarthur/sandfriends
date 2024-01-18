import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../Remote/NetworkResponse.dart';
import '../../../SharedComponents/Model/City.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/CitySelectorModal.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../../MatchSearchFilter/Model/CustomFilter.dart';

class StoreSearchViewModel extends ChangeNotifier {
  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;
  bool canTapBackground = true;

  String get titleText =>
      "Busca quadra - ${currentCustomFilter.sport.description}";

  late CustomFilter defaultCustomFilter;
  late CustomFilter currentCustomFilter;

  bool get customFilterHasChanged => defaultCustomFilter != currentCustomFilter;

  void initMatchSearchViewModel(BuildContext context, int sportId) {
    defaultCustomFilter = CustomFilter(
        orderBy: OrderBy.price,
        sport: Provider.of<UserProvider>(context, listen: false)
            .user!
            .preferenceSport!);
    currentCustomFilter = CustomFilter.copyFrom(defaultCustomFilter);
  }

  City? selectedCity;

  void openCitySelectorModal(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    if (Provider.of<CategoriesProvider>(context, listen: false)
        .availableRegions
        .isEmpty) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .categoriesProviderRepo
          .getAvailableRegions(context)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Provider.of<CategoriesProvider>(context, listen: false)
              .setAvailableRegions(response.responseBody!);

          displayCitySelector(context);
        } else {
          modalMessage = SFModalMessage(
            message: response.userMessage!,
            onTap: () => openCitySelectorModal(context),
            isHappy: false,
            buttonText: "Tentar novamente",
          );
          pageStatus = PageStatus.ERROR;
          notifyListeners();
        }
      });
    } else {
      displayCitySelector(context);
    }
  }

  void displayCitySelector(BuildContext context) {
    widgetForm = CitySelectorModal(
      regions: Provider.of<CategoriesProvider>(context, listen: false)
          .availableRegions,
      onSelectedCity: (city) {
        selectedCity = city;
        pageStatus = PageStatus.OK;
        notifyListeners();
      },
      userCity: Provider.of<UserProvider>(context, listen: false).user!.city,
      onReturn: () => closeModal(),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void searchStores(BuildContext context) {}

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> goToSearchFilter(BuildContext context) async {
    Navigator.pushNamed(context, "/match_search_filter", arguments: {
      'defaultCustomFilter': defaultCustomFilter,
      'currentCustomFilter': currentCustomFilter,
      'selectedCityId': selectedCity,
      'hideOrderBy': true,
    }).then((newFilter) {
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
}
