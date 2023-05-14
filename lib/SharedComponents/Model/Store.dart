import 'package:sandfriends/SharedComponents/Model/City.dart';

import 'Court.dart';

class Store {
  final int idStore;
  final String name;
  final String address;
  final String addressNumber;
  final String neighbourhood;
  final City city;
  final String latitude;
  final String longitude;
  final String imageUrl;
  final String descriptionText;
  final String instagram;
  final String phone;
  List<String> photos = [];
  List<Court> courts = [];

  Store({
    required this.idStore,
    required this.name,
    required this.address,
    required this.addressNumber,
    required this.neighbourhood,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.descriptionText,
    required this.instagram,
    required this.phone,
  });

  String get completeAddress => "$address, $addressNumber - $neighbourhood";

  factory Store.fromJson(Map<String, dynamic> json) {
    var newStore = Store(
      idStore: json['IdStore'],
      name: json['Name'],
      address: json['Address'],
      addressNumber: json['AddressNumber'],
      neighbourhood: json['Neighbourhood'],
      city: City.fromJsonUser(json['City']),
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      imageUrl: json['Logo'],
      descriptionText: json['Description'],
      instagram: json['Instagram'],
      phone: json['PhoneNumber1'],
    );
    for (int i = 0; i < json['StorePhotos'].length; i++) {
      newStore.photos.add(json['StorePhotos'][i]['Photo']);
    }
    for (var court in json['Courts']) {
      newStore.courts.add(Court.fromJson(
        court,
      ));
    }

    return newStore;
  }

  factory Store.fromJsonMatch(Map<String, dynamic> json) {
    var newStore = Store(
      idStore: json['IdStore'],
      name: json['Name'],
      address: json['Address'],
      addressNumber: json['AddressNumber'],
      neighbourhood: json['Neighbourhood'],
      city: City.fromJsonUser(json['City']),
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      imageUrl: json['Logo'],
      descriptionText: json['Description'],
      instagram: json['Instagram'],
      phone: json['PhoneNumber1'],
    );
    for (int i = 0; i < json['StorePhotos'].length; i++) {
      newStore.photos.add(json['StorePhotos'][i]['Photo']);
    }

    return newStore;
  }
}
