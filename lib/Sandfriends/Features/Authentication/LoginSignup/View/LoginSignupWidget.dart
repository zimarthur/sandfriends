import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
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
                      Provider.of<EnvironmentProvider>(context, listen: false)
                              .environment
                              .isSandfriendsAulas
                          ? r"assets/image_login_aulas.png"
                          : r"assets/image_login.png",
                      height: height * 0.3,
                      fit: BoxFit.fill,
                      width: width,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      Provider.of<EnvironmentProvider>(context, listen: false)
                              .environment
                              .isSandfriendsAulas
                          ? r"assets/logo_brand_aulas.png"
                          : r"assets/logo_brand.png",
                      height: height * 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Padding(padding: EdgeInsets.only(bottom: height * 0.04)),
                  Provider.of<EnvironmentProvider>(context, listen: false)
                          .environment
                          .isIos
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SvgPicture.asset(
                                      r'assets/icon/divider.svg',
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text(
                                    "ou entre com sua conta",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Expanded(
                                    child: SvgPicture.asset(
                                      r'assets/icon/divider.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(bottom: height * 0.03)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.viewModel
                                        .googleAccountSelector(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: secondaryPaper,
                                      borderRadius: BorderRadius.circular(
                                        defaultBorderRadius,
                                      ),
                                      border: Border.all(
                                        color: divider,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: divider,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        r"assets/icon/google_logo.svg",
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.viewModel
                                        .appleAccountSelector(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: secondaryPaper,
                                      borderRadius: BorderRadius.circular(
                                        defaultBorderRadius,
                                      ),
                                      border: Border.all(
                                        color: divider,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1,
                                          color: divider,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        r"assets/icon/apple_logo.svg",
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              r'assets/icon/divider.svg',
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(bottom: height * 0.02)),
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
                                    SvgPicture.asset(
                                      r"assets/icon/google_logo.svg",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
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
