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
      String uri = completeUrl ?? getCompleteUrl(context, endPoint);
      if (Provider.of<EnvironmentProvider>(context, listen: false)
          .environment
          .isDev) {
        print(uri);
      }
      final response = await http.get(Uri.parse(uri));
      return returnResponse(
        response,
      );
    } on SocketException catch (e) {
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
    try {
      String uri = completeUrl ?? getCompleteUrl(context, endPoint);
      if (Provider.of<EnvironmentProvider>(context, listen: false)
          .environment
          .isDev) {
        print(uri);
        print(body);
      }
      final response = await http
          .post(
            Uri.parse(uri),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body,
          )
          .timeout(
            const Duration(
              seconds: 100,
            ),
          );
      if (Provider.of<EnvironmentProvider>(context, listen: false)
          .environment
          .isDev) {
        print("Status Code: ${response.statusCode}");
        print("Body: ${response.body}");
      }
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
    Map<String, dynamic>? responseBody;
    try {
      responseBody = json.decode(
        response.body,
      );
    } catch (e) {}

    if (statusCode.startsWith("2")) {
      if (statusCode == "200") {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.success,
          responseBody: response.body,
        );
      }
      String? title =
          responseBody == null ? response.body : responseBody['Title'];
      String? description =
          responseBody == null ? null : responseBody['Description'];
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
