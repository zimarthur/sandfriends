import 'package:sandfriends/Common/Model/Infrastructure.dart';

import '../City.dart';
import '../Court.dart';

abstract class Store {
  int idStore;
  String name;
  String? logo;
  String address;
  String addressNumber;
  String neighbourhood;
  City city;
  double latitude;
  double longitude;
  String phoneNumber;
  String url;

  List<Court> courts = [];
  List<Infrastructure> infrastructures = [];

  Store({
    required this.idStore,
    required this.name,
    required this.logo,
    required this.address,
    required this.addressNumber,
    required this.neighbourhood,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.url,
  });

  String get completeAddress =>
      "$address, $addressNumber - $neighbourhood, ${city.name}";

  String get neighbourhoodAddress =>
      "$address, $addressNumber - $neighbourhood";

  String get shortAddress => "$address, $addressNumber";
}
