import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../../Model/Region.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../Utils/PageStatus.dart';

class CitySelectorViewModel extends ChangeNotifier {
  PageStatus modalStatus = PageStatus.LOADING;
  List<Region> regions = [];

  void initModal(
    BuildContext context,
    bool onlyAvailableCities,
  ) {
    if (onlyAvailableCities) {
      if (Provider.of<CategoriesProvider>(context, listen: false)
          .availableRegions
          .isEmpty) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .categoriesProviderRepo
            .getAvailableRegions(context)
            .then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            Map<String, dynamic> responseBody = json.decode(
              response.responseBody!,
            );
            Provider.of<CategoriesProvider>(context, listen: false)
                .setAvailableRegions(responseBody);
            regions = Provider.of<CategoriesProvider>(context, listen: false)
                .availableRegions;
            modalStatus = PageStatus.OK;
            notifyListeners();
          } else {
            //TODO
          }
        });
      } else {
        regions = Provider.of<CategoriesProvider>(context, listen: false)
            .availableRegions;
        modalStatus = PageStatus.OK;
        notifyListeners();
      }
    } else {
      if (Provider.of<CategoriesProvider>(context, listen: false)
          .regions
          .isEmpty) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .categoriesProviderRepo
            .getAllCities(context)
            .then((response) {
          if (response.responseStatus == NetworkResponseStatus.success) {
            Map<String, dynamic> responseBody = json.decode(
              response.responseBody!,
            );
            Provider.of<CategoriesProvider>(context, listen: false)
                .setRegions(responseBody);

            regions =
                Provider.of<CategoriesProvider>(context, listen: false).regions;
            modalStatus = PageStatus.OK;
            notifyListeners();
          } else {
            //TODO
          }
        });
      } else {
        regions =
            Provider.of<CategoriesProvider>(context, listen: false).regions;
        modalStatus = PageStatus.OK;
        notifyListeners();
      }
    }
  }
}
