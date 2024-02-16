import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../Common/Model/AppMatch.dart';
import '../../../../Common/Model/AvailableCourt.dart';
import '../../../../Common/Model/AvailableDay.dart';
import '../../../../Common/Model/AvailableHour.dart';
import '../../../../Common/Model/AvailableStore.dart';
import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Store.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import 'package:geolocator/geolocator.dart';

import '../../Court/Model/CourtAvailableHours.dart';
import '../../Court/Model/HourPrice.dart';

Tuple2<List<AvailableDay>, List<AppMatch>> matchSearchDecoder(
  BuildContext context,
  String response,
) {
  List<AvailableDay> availableDays = [];
  List<AppMatch> openMatches = [];

  List<Store> receivedStores = [];

  final responseBody = json.decode(response);
  final responseDates = responseBody['Dates'];
  final responseStores = responseBody['Stores'];
  final responseOpenMatches = responseBody['OpenMatches'];

  for (var store in responseStores) {
    Store newStore = Store.fromJson(
      store,
    );
    if (Provider.of<UserProvider>(context, listen: false).userLocation !=
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
    receivedStores.add(
      newStore,
    );
  }

  for (var date in responseDates) {
    DateTime newDate = DateFormat('dd/MM/yyyy').parse(date["Date"]);
    List<AvailableStore> availableStores = [];
    for (var store in date["Stores"]) {
      Store newStore = receivedStores
          .firstWhere((recStore) => recStore.idStore == store["IdStore"]);
      List<AvailableHour> availableHours = [];
      for (var hour in store["Hours"]) {
        List<AvailableCourt> availableCourts = [];
        for (var court in hour["Courts"]) {
          availableCourts.add(
            AvailableCourt(
              court: newStore.courts.firstWhere(
                  (recCourt) => recCourt.idStoreCourt == court["IdStoreCourt"]),
              price: court["Price"],
            ),
          );
        }
        availableHours.add(
          AvailableHour(
            Hour(
              hour: hour["TimeInteger"],
              hourString: hour["TimeBegin"],
            ),
            availableCourts,
          ),
        );
      }
      availableStores.add(
        AvailableStore(
          store: newStore,
          availableHours: availableHours,
        ),
      );
    }
    availableDays.add(
      AvailableDay(
        day: newDate,
        stores: availableStores,
      ),
    );
  }
  for (var openMatch in responseOpenMatches) {
    openMatches.add(
      AppMatch.fromJson(
        openMatch,
        Provider.of<CategoriesProvider>(context, listen: false).hours,
        Provider.of<CategoriesProvider>(context, listen: false).sports,
      ),
    );
  }

  return Tuple2<List<AvailableDay>, List<AppMatch>>(availableDays, openMatches);
}
