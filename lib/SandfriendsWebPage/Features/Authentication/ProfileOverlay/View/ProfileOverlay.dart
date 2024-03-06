import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFLoading.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/PageStatus.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/Enum/EnumLoginSignupWidgets.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/ForgotPassword.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/Login.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/Signup.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/User.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/ViewModel/ProfileOverlayViewModel.dart';

import '../../../../../Common/Utils/Validators.dart';
import '../../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';

class LoginSignup extends StatefulWidget {
  StandardScreenViewModel parentScreen;
  VoidCallback? close;
  LoginSignup({
    required this.parentScreen,
    this.close,
    super.key,
  });

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final controller = TextEditingController();

  late ProfileOverlayViewModel viewModel;
  @override
  void initState() {
    viewModel = ProfileOverlayViewModel(
      overlayClose: widget.close,
      parentViewModel: widget.parentScreen,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileOverlayViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ProfileOverlayViewModel>(
        builder: (context, viewModel, _) {
          return Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                color: secondaryPaper,
                border: Border.all(
                  color: divider,
                ),
              ),
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              child: Column(
                children: [
                  if (widget.close != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => widget.close!(),
                        child: SvgPicture.asset(
                          r"assets/icon/x.svg",
                          color: textDarkGrey,
                          height: 15,
                        ),
                      ),
                    ),
                  Provider.of<UserProvider>(context).user != null
                      ? User(
                          onTapProfile: () => viewModel.onTapProfile(context),
                          onTapMatches: () => viewModel.onTapMatches(context),
                          onTapCallSupport: () =>
                              viewModel.onTapCallSupport(context),
                          onTapCallLogout: () =>
                              viewModel.onTapCallLogout(context),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (viewModel.currentWidget !=
                                    EnumLoginSignupWidget.Login)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: defaultPadding),
                                    child: InkWell(
                                      onTap: () => viewModel.goToLogin(),
                                      child: SvgPicture.asset(
                                        r"assets/icon/arrow_left.svg",
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ),
                                Text(
                                  viewModel.currentWidget ==
                                          EnumLoginSignupWidget.Login
                                      ? "Login"
                                      : viewModel.currentWidget ==
                                              EnumLoginSignupWidget
                                                  .ForgotPassword
                                          ? "Esqueci minha senha"
                                          : "Criar conta",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            viewModel.widgetStatus != PageStatus.OK
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: defaultPadding,
                                      ),
                                      child: viewModel.widgetStatus ==
                                              PageStatus.LOADING
                                          ? SFLoading()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  viewModel.messageTitle!,
                                                  style: TextStyle(
                                                    color: primaryBlue,
                                                  ),
                                                ),
                                                if (viewModel
                                                        .messageDescription !=
                                                    null)
                                                  Text(
                                                    viewModel
                                                        .messageDescription!,
                                                    style: TextStyle(
                                                      color: textDarkGrey,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                              ],
                                            ),
                                    ),
                                  )
                                : viewModel.currentWidget ==
                                        EnumLoginSignupWidget.Login
                                    ? Login(
                                        onTapLogin: () =>
                                            viewModel.onTapLogin(context),
                                        onTapLoginGoogle: () =>
                                            viewModel.googleLogin(context),
                                      )
                                    : viewModel.currentWidget ==
                                            EnumLoginSignupWidget.ForgotPassword
                                        ? ForgotPassword(
                                            onTapForgotPassword: () => viewModel
                                                .onTapForgotPassword(context),
                                          )
                                        : Signup(
                                            onTapCreateAccount: () => viewModel
                                                .onTapCreateAccount(context),
                                          )
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
