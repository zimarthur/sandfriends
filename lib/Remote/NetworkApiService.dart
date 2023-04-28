import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'AppException.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String baseUrl, String aditionalUrl) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(baseUrl + aditionalUrl));
      responseJson = returnResponse(response, true);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String baseUrl, String aditionalUrl, String body,
      bool expectResponse) async {
    try {
      print(body);
      print(baseUrl);
      print(aditionalUrl);
      final response = await http.post(
        Uri.parse(baseUrl + aditionalUrl),
        headers: {
          //"Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
          // "Access-Control-Allow-Headers":
          //     "Origin, X-Requested-With, Content-Type, Accept",
          'Content-Type': 'application/json'
        },
        //{'Content-Type': 'application/json'},
        body: body,
      );
      return returnResponse(response, expectResponse);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  dynamic returnResponse(http.Response response, bool expectResponse) {
    switch (response.statusCode) {
      case 200:
        if (expectResponse) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          return responseBody;
        } else {
          return response.statusCode;
        }
      case 500:
        throw "Ops, tivemos um problema.\n Tente Novamente";
      default:
        throw response.body;
    }
  }
}
