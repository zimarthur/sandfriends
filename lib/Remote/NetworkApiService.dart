import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future<NetworkResponse> getResponse(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return returnResponse(
        response,
      );
    } on SocketException {
      return NetworkResponse(
        responseStatus: NetworkResponseStatus.error,
        userMessage: "Ops, você está sem acesso à internet",
      );
    }
  }

  @override
  Future<NetworkResponse> postResponse(
    String url,
    String body,
  ) async {
    print(body);
    print(url);
    try {
      final response = await http
          .post(
            Uri.parse(url),
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
        userMessage: "Ops, você está sem acesso à internet",
      );
    } on TimeoutException catch (_) {
      return NetworkResponse(
        responseStatus: NetworkResponseStatus.error,
        userMessage: "Ops, ocorreu um problema de conexão.",
      );
    }
  }

  NetworkResponse returnResponse(http.Response response) {
    String statusCode = response.statusCode.toString();
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
          userMessage: response.body,
        );
      } else if (statusCode == "232") {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.expiredToken,
          userMessage: "Sua sessão foi expirada. Faça login novamente.",
        );
      } else {
        return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          userMessage: response.body,
        );
      }
    } else if (statusCode.startsWith("5")) {
      return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          userMessage:
              "Ops, ocorreu um problema de conexão.\n Tente Novamente");
    } else {
      return NetworkResponse(
          responseStatus: NetworkResponseStatus.error,
          userMessage: "Ops, ocorreu erro.\n Tente Novamente");
    }
  }
}
