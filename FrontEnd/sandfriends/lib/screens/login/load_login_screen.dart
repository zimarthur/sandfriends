import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../../models/user.dart';

Future<void> ValidateAccessToken(BuildContext context) async {
  const storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: "AccessToken");
  bool isNewUser = false;
  String newAccessToken;

  if (accessToken != null) {
    var response = await http.post(
      Uri.parse('https://www.sandfriends.com.br/ValidateToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, Object>{
          'AccessToken': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      final newAccessToken = responseBody['AccessToken'];
      await storage.write(key: "AccessToken", value: newAccessToken);
      if (responseBody['EmailConfirmationDate'] == null) {
        context.goNamed('login_signup');
      } else if (responseBody['IsNewUser'] == true) {
        context.goNamed('new_user_welcome');
      } else {
        response = await http.get(Uri.parse(
            'https://www.sandfriends.com.br/GetUser/' + newAccessToken));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          Provider.of<User>(context, listen: false).FirstName =
              responseBody['FirstName'];
          Provider.of<User>(context, listen: false).LastName =
              responseBody['LastName'];
          Provider.of<User>(context, listen: false).Gender =
              responseBody['Gender'];
          Provider.of<User>(context, listen: false).PhoneNumber =
              responseBody['PhoneNumber'];
          Provider.of<User>(context, listen: false).Birthday =
              responseBody['Birthday'];
          Provider.of<User>(context, listen: false).Rank = responseBody['Rank'];
          Provider.of<User>(context, listen: false).Height =
              responseBody['Height'];
          Provider.of<User>(context, listen: false).HandPreference =
              responseBody['HandPreference'];
          Provider.of<User>(context, listen: false).Photo =
              responseBody['Photo'];
          context.goNamed('home', params: {'initialPage': 'null'});
        } else {
          print("deu ruim");
        }
      }
    } else {
      //o token não é valido
      context.goNamed('login_signup');
    }
  } else {
    //não tem token
    context.goNamed('login_signup');
  }
}

class LoadLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ValidateAccessToken(context);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.colors.secondaryBack,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                r'assets\icon\sand_bar.svg',
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Center(
                child: Image.asset(
              r'assets\icon\logo.png',
              alignment: Alignment.center,
              height: 120,
            )),
          ],
        ),
      ),
    );
  }
}
