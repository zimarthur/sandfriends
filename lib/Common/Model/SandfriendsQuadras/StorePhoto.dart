import 'package:flutter/foundation.dart';

class StorePhoto {
  int idStorePhoto;
  String photo;
  bool isNewPhoto;
  dynamic newPhoto;

  StorePhoto({
    required this.idStorePhoto,
    required this.photo,
    this.isNewPhoto = false,
    this.newPhoto,
  });

  factory StorePhoto.fromJson(Map<String, dynamic> parsedJson) {
    return StorePhoto(
      idStorePhoto: parsedJson["IdStorePhoto"],
      photo: parsedJson["Photo"],
    );
  }

  factory StorePhoto.copyWith(StorePhoto refPhoto) {
    return StorePhoto(
      idStorePhoto: refPhoto.idStorePhoto,
      photo: refPhoto.photo,
    );
  }
}
