import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ViewModel/LoginViewModel.dart';

class LoginWidget extends StatefulWidget {
  LoginViewModel viewModel;
  LoginWidget({
    required this.viewModel,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(2 * defaultPadding),
      height: height * 0.85,
      width: width * 0.3 < 350 ? 350 : width * 0.3,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  r'assets/icon/full_logo_positive.svg',
                  //height: height * 0.2,
                ),
                const SizedBox(
                  height: defaultPadding * 2,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SFTextField(
                      labelText: "Email",
                      pourpose: TextFieldPourpose.Email,
                      prefixIcon: SvgPicture.asset(r"assets/icon/email.svg"),
                      controller: widget.viewModel.userController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: defaultPadding,
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
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<LoginViewModel>(context, listen: false)
                              .keepConnected = !Provider.of<LoginViewModel>(
                                  context,
                                  listen: false)
                              .keepConnected;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                              activeColor: primaryBlue,
                              value: Provider.of<LoginViewModel>(context)
                                  .keepConnected,
                              onChanged: (value) {
                                setState(() {
                                  Provider.of<LoginViewModel>(context,
                                          listen: false)
                                      .keepConnected = value!;
                                });
                              }),
                          const Text(
                            "Mantenha-me conectado",
                            style: TextStyle(color: textDarkGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2 * defaultPadding,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SFButton(
                      buttonLabel: "Entrar",
                      buttonType: ButtonType.Primary,
                      onTap: (() {
                        Provider.of<LoginViewModel>(context, listen: false)
                            .onTapLogin(context);
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
                            color: textDarkGrey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: 'Ainda não se cadastrou? ',
                      style: TextStyle(
                        color: textDarkGrey,
                        fontFamily: 'Lexend',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Cadastre já!',
                          style: const TextStyle(
                              color: textBlue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.viewModel.onTapCreateAccount(context);
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
