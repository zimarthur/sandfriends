import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../Remote/ApiEndPoints.dart';
import '../../../../Remote/NetworkApiService.dart';
import '../../../../Remote/NetworkResponse.dart';

class SettingsRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> updateStoreInfo(
      BuildContext context, Store store, bool changedLogo) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.updateStoreInfo,
      jsonEncode(
        <String, Object>{
          "IdStore": store.idStore,
          "Name": store.name,
          "Address": store.address,
          "AddressNumber": store.addressNumber,
          "City": store.city.name,
          "State": store.city.state.uf,
          "PhoneNumber1": store.phoneNumber,
          "PhoneNumber2": store.ownerPhoneNumber ?? "",
          "Description": store.description ?? "",
          "Instagram": store.instagram ?? "",
          "Cnpj": store.cnpj ?? "",
          "Cep": store.cep,
          "Neighbourhood": store.neighbourhood,
          "Logo": changedLogo ? store.logo : "",
          "Photos": [
            for (var photo in store.photos)
              if (photo.isNewPhoto)
                {
                  "IdStorePhoto": "",
                  "Photo": base64Encode(photo.newPhoto),
                }
              else
                {
                  "IdStorePhoto": photo.idStorePhoto,
                  "Photo": photo.photo,
                }
          ]
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> allowNotifications(
    BuildContext context,
    String accessToken,
    bool allowNotifications,
    String notificationsToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.allowNotifications,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
          "AllowNotifications": allowNotifications,
          "NotificationsToken": notificationsToken,
        },
      ),
    );
    return response;
  }

  Future<NetworkResponse> deleteAccount(
    BuildContext context,
    String accessToken,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.deleteAccountEmployee,
      jsonEncode(
        <String, Object>{
          "AccessToken": accessToken,
        },
      ),
    );
    return response;
  }
}
