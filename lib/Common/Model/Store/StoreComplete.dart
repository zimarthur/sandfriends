import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/City.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceStore.dart';
import 'package:sandfriends/Common/Model/Store/Store.dart';
import '../Court.dart';
import '../SandfriendsQuadras/StorePhoto.dart';

class StoreComplete extends Store {
  String? ownerPhoneNumber;
  String? cnpj;
  String cep;
  String cpf;
  DateTime approvalDate;
  String? description;
  String? instagram;

  List<StorePhoto> photos = [];
  List<HourPriceStore> prices = [];

  StoreComplete({
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
    required this.cpf,
    required this.cep,
    required this.approvalDate,
    this.ownerPhoneNumber,
    this.cnpj,
  });

  factory StoreComplete.fromJson(Map<String, dynamic> json) {
    var newStore = StoreComplete(
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
      cnpj: json["Cnpj"],
      cpf: json["Cpf"],
      cep: json["Cep"],
      approvalDate: DateFormat("dd/MM/yyyy").parse(
        json["ApprovalDate"],
      ),
      ownerPhoneNumber: json["PhoneNumber2"],
    );
    for (var photo in json["StorePhotos"]) {
      newStore.photos.add(
        StorePhoto.fromJson(
          photo,
        ),
      );
    }

    return newStore;
  }

  factory StoreComplete.copyWith(StoreComplete refStore) {
    var newStore = StoreComplete(
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
      approvalDate: refStore.approvalDate,
      cep: refStore.cep,
      cpf: refStore.cpf,
      cnpj: refStore.cnpj,
      ownerPhoneNumber: refStore.ownerPhoneNumber,
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
