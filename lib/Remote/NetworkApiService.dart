import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

class NetworkApiService {
  Future<NetworkResponse> getResponse(
    BuildContext context,
    String endPoint, {
    String? completeUrl,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(completeUrl ?? getCompleteUrl(context, endPoint)));
      return returnResponse(
        response,
      );
    } on SocketException {
      return NetworkResponse(
        responseStatus: NetworkResponseStatus.error,
        responseTitle: "Ops, você está sem acesso à internet",
      );
    }
  }

  Future<NetworkResponse> postResponse(
    BuildContext context,
    String endPoint,
    String body, {
    String? completeUrl,
  }) async {
    print(body);
    print(endPoint);
    try {
      final response = await http
          .post(
            Uri.parse(completeUrl ?? getCompleteUrl(context, endPoint)),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body,
          )
          .timeout(
            const Duration(
              seconds: 10,
            ),
          );
      return returnResponse(response);
    } on SocketException {
      return NetworkResponse(
        responseStatus: NetworkResponseStatus.error,
        responseTitle: "Ops, você está sem acesso à internet",
      );
    } on TimeoutException catch (_) {
      return NetworkResponse(
        responseStatus: NetworkResponseStatus.error,
        responseTitle: "Ops, ocorreu um problema de conexão.",
      );
    }
  }

  NetworkResponse returnResponse(http.Response response) {
    String statusCode = response.statusCode.toString();
    Map<String, dynamic>? responseBody = json.decode(
      response.body,
    );
    String title = responseBody == null ? response.body : responseBody['Title'];
    String? description =
        responseBody == null ? null : responseBody['Description'];
    print(statusCode);
    print(response.body);

    if (statusCode.startsWith("2")) {
      if (statusCode == "200") {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.success,
          responseBody: response.body,
        );
      }
      if (statusCode == "231") {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.alert,
          responseTitle: title,
          responseDescription: description,
        );
      } else if (statusCode == "232") {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.expiredToken,
          responseTitle: "Sua sessão foi expirada. Faça login novamente.",
        );
      } else {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          responseTitle: title,
          responseDescription: description,
        );
      }
    } else if (statusCode.startsWith("5")) {
      return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          responseTitle:
              "Ops, ocorreu um problema de conexão.\n Tente Novamente");
    } else {
      return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          responseTitle: "Ops, ocorreu erro.\n Tente Novamente");
    }
  }

  String getCompleteUrl(
    BuildContext context,
    String endPoint,
  ) {
    return Provider.of<EnvironmentProvider>(context, listen: false)
        .urlBuilder(endPoint);
  }
}
