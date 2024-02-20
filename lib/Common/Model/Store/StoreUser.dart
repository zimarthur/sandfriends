import '../City.dart';
import '../Court.dart';
import 'Store.dart';

class StoreUser extends Store {
  double? distanceBetweenPlayer;
  String description;
  String instagram;

  List<String> photos = [];

  StoreUser({
    required super.idStore,
    required super.name,
    required super.logo,
    required super.address,
    required super.addressNumber,
    required super.neighbourhood,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required this.description,
    required this.instagram,
  });

  factory StoreUser.fromJson(Map<String, dynamic> json) {
    var newStore = StoreUser(
      idStore: json['IdStore'],
      name: json['Name'],
      address: json['Address'],
      addressNumber: json['AddressNumber'],
      neighbourhood: json['Neighbourhood'],
      city: City.fromJsonUser(json['City']),
      latitude: double.parse(
        json['Latitude'],
      ),
      longitude: double.parse(
        json['Longitude'],
      ),
      logo: json['Logo'],
      description: json['Description'],
      instagram: json['Instagram'],
      phoneNumber: json['PhoneNumber1'],
    );
    for (int i = 0; i < json['StorePhotos'].length; i++) {
      newStore.photos.add(json['StorePhotos'][i]['Photo']);
    }
    if (json['Courts'] != null) {
      for (var court in json['Courts']) {
        newStore.courts.add(Court.fromJson(
          court,
        ));
      }
    }

    return newStore;
  }

  factory StoreUser.copyWith(StoreUser refStore) {
    var newStore = StoreUser(
      idStore: refStore.idStore,
      name: refStore.name,
      address: refStore.address,
      addressNumber: refStore.addressNumber,
      neighbourhood: refStore.neighbourhood,
      city: refStore.city,
      latitude: refStore.latitude,
      longitude: refStore.longitude,
      logo: refStore.logo,
      description: refStore.description,
      instagram: refStore.instagram,
      phoneNumber: refStore.phoneNumber,
    );
    for (int i = 0; i < refStore.photos.length; i++) {
      newStore.photos.add(refStore.photos[i]);
    }
    for (var court in refStore.courts) {
      newStore.courts.add(
        Court.copyFrom(
          court,
        ),
      );
    }
    return newStore;
  }
}
