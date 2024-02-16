import 'package:flutter/material.dart';
import '../../../../../Remote/ApiEndPoints.dart';
import '../../../../../Remote/NetworkApiService.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Remote/Url.dart';
import '../Model/CreateAccountStore.dart';

class CreateAccountRepo {
  final _apiService = NetworkApiService();

  Future<NetworkResponse> getStoreFromCnpj(
      BuildContext context, String cnpj) async {
    NetworkResponse response = await _apiService.getResponse(
      context,
      "",
      completeUrl: cnpjUrl + cnpj,
    );
    return response;
  }

  Future<NetworkResponse> createAccount(
    BuildContext context,
    CreateAccountStore store,
  ) async {
    NetworkResponse response = await _apiService.postResponse(
      context,
      ApiEndPoints.createAccountStore,
      CreateAccountStoreToJson(store),
    );
    return response;
  }
}
