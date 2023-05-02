import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'AppException.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future<NetworkResponse> getResponse(
      String baseUrl, String aditionalUrl) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + aditionalUrl));
      return returnResponse(
        response,
      );
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future<NetworkResponse> postResponse(
    String baseUrl,
    String aditionalUrl,
    String body,
  ) async {
    print(body);
    print(baseUrl);
    print(aditionalUrl);
    final response = await http.post(
      Uri.parse(baseUrl + aditionalUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    return returnResponse(response);
  }

  NetworkResponse returnResponse(http.Response response) {
    String statusCode = response.statusCode.toString();
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