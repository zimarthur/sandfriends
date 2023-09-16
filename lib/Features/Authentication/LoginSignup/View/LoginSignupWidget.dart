import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../Utils/Constants.dart';
import '../ViewModel/LoginSignupViewModel.dart';

class LoginSignupWidget extends StatefulWidget {
  final LoginSignupViewModel viewModel;
  const LoginSignupWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<LoginSignupWidget> createState() => _LoginSignupWidgetState();
}

class _LoginSignupWidgetState extends State<LoginSignupWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: secondaryBack,
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
                      r"assets/image_login.png",
                      height: height * 0.3,
                      fit: BoxFit.fill,
                      width: width,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      r"assets/icon/logo_brand.png",
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
                      onTap: () => Navigator.pushNamed(context, '/login'),
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
                      isPrimary: false,
                      onTap: () =>
                          Navigator.pushNamed(context, '/create_account'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: height * 0.04)),
            if (!Platform.isIOS)
              Column(
                children: [
                  SvgPicture.asset(
                    r'assets/icon/divider.svg',
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.02)),
                  InkWell(
                    onTap: () {
                      widget.viewModel.googleAccountSelector(context);
                    },
                    highlightColor: primaryBlue,
                    child: Ink(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Entrar com minha conta Google",
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          SvgPicture.asset(r"assets/icon/google_logo.svg")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(child: Container()),
            SizedBox(
              height: height * 0.06,
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(
                  r'assets/icon/sand_bar.svg',
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
