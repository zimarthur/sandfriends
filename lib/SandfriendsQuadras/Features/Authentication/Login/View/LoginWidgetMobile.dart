import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../ViewModel/LoginViewModel.dart';

class LoginWidgetMobile extends StatefulWidget {
  LoginViewModel viewModel;
  LoginWidgetMobile({
    super.key,
    required this.viewModel,
  });

  @override
  State<LoginWidgetMobile> createState() => _LoginWidgetMobileState();
}

class _LoginWidgetMobileState extends State<LoginWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 2 * defaultPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue,
            secondaryLightBlue,
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              key: widget.viewModel.loginFormKey,
              child: Column(
                children: [
                  Image.asset(
                    r'assets/full_logo_negative_284_courts.png',
                    width: width * 0.8,
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: textWhite.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                      border: Border.all(
                        color: divider,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: 2 * defaultPadding,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        SFTextField(
                          labelText: "E-mail",
                          pourpose: TextFieldPourpose.Email,
                          prefixIcon:
                              SvgPicture.asset(r"assets/icon/email.svg"),
                          controller: widget.viewModel.userController,
                          validator: (value) =>
                              emptyCheck(value, "Digite seu e-mail"),
                          onSubmit: (p0) =>
                              widget.viewModel.onTapLogin(context),
                        ),
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        SFTextField(
                          controller: widget.viewModel.passwordController,
                          labelText: "Senha",
                          prefixIcon: SvgPicture.asset(r"assets/icon/lock.svg"),
                          suffixIcon:
                              SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                          suffixIconPressed:
                              SvgPicture.asset(r"assets/icon/eye_open.svg"),
                          pourpose: TextFieldPourpose.Password,
                          validator: (value) =>
                              emptyCheck(value, "Digite sua senha"),
                          onSubmit: (p0) =>
                              widget.viewModel.onTapLogin(context),
                        ),
                        InkWell(
                          onTap: () => widget.viewModel.keepConnected =
                              !widget.viewModel.keepConnected,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: primaryBlue,
                                value: widget.viewModel.keepConnected,
                                onChanged: (value) =>
                                    widget.viewModel.keepConnected = value!,
                              ),
                              const Text(
                                "Mantenha-me conectado",
                                style: TextStyle(color: textWhite),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3 * defaultPadding,
                        ),
                        SFButton(
                          buttonLabel: "Entrar",
                          onTap: (() {
                            widget.viewModel.onTapLogin(context);
                          }),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              widget.viewModel.onTapForgotPassword(context);
                            });
                          },
                          child: const Text(
                            "Esqueci minha senha",
                            style: TextStyle(
                              color: textWhite,
                              decoration: TextDecoration.underline,
                              decorationColor: textWhite,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Ainda não cadastrou sua quadra?\n',
                      style: const TextStyle(
                        color: textWhite,
                        fontFamily: 'Lexend',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Cadastre já!',
                          style: const TextStyle(
                              color: textBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lexend',
                              decoration: TextDecoration.underline,
                              decorationColor: textBlue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.viewModel.onTapCreateAccount(context);
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
