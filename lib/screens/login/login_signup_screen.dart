import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/main.dart';

import '../../api/google_signin_api.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      googleSignOut();
    });
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          color: AppTheme.colors.secondaryBack,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.4,
                  width: width,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          r"assets\icon\image_login.png",
                          height: height * 0.3,
                          fit: BoxFit.fill,
                          width: width,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          r"assets\icon\logo_brand.png",
                          height: height * 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: height * 0.14)),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: height * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                        child: SFButton(
                          buttonLabel: "Login",
                          buttonType: ButtonType.Primary,
                          onTap: () => context.goNamed('login'),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.02)),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: height * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                        child: SFButton(
                          buttonLabel: "Criar conta",
                          buttonType: ButtonType.Secondary,
                          onTap: () => context.goNamed('create_account'),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: height * 0.04)),
                SvgPicture.asset(
                  r'assets\icon\divider.svg',
                ),
                Padding(padding: EdgeInsets.only(bottom: height * 0.02)),
                InkWell(
                  onTap: () {
                    googleSignIn(context);
                  },
                  highlightColor: AppTheme.colors.primaryBlue,
                  child: Ink(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Entrar com minha conta Google",
                            style: TextStyle(
                              color: AppTheme.colors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SvgPicture.asset(r"assets\icon\google_logo.svg")
                      ],
                    ),
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: height * 0.06,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SvgPicture.asset(
                      r'assets\icon\sand_bar.svg',
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future googleSignOut() async {
  bool? isLoggedGoogle = await GoogleSignInApi.isLoggedIn();
  if (isLoggedGoogle != null && isLoggedGoogle == true) {
    await GoogleSignInApi.logout();
  }
}

Future<String?> googleSignIn(BuildContext context) async {
  final user = await GoogleSignInApi.login();

  if (user == null) {
    print("erro");
  } else {
    // ignore: avoid_single_cascade_in_expression_statements
    user.authentication
      ..then((googleKey) {
        ValidateLogin(context, user.email);
      }).catchError((err) {
        return null;
      });
  }
  return null;
}

Future<void> ValidateLogin(BuildContext context, String email) async {
  var response = await http.post(
    Uri.parse('https://www.sandfriends.com.br/LogIn'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'Email': email,
      'Password': '',
      'ThirdPartyLogin': true,
    }),
  );

  if (response.statusCode == 200) {
    const storage = FlutterSecureStorage();

    Map<String, dynamic> responseBody = json.decode(response.body);
    final newAccessToken = responseBody['AccessToken'];

    await storage.write(key: "AccessToken", value: newAccessToken);

    final responseLogin = responseBody['UserLogin'];

    if (responseLogin['IsNewUser'] == true) {
      context.goNamed('new_user_welcome');
    } else {
      Provider.of<UserProvider>(context, listen: false).resetUserProvider();
      context.goNamed('home', params: {'initialPage': 'feed_screen'});
    }
  } else {
    context.goNamed('login_signup');
  }
}
