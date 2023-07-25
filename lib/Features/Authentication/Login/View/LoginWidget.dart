import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../SharedComponents/View/SFButton.dart';
import '../../../../SharedComponents/View/SFTextField.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';

import '../ViewModel/LoginViewModel.dart';

class LoginWidget extends StatefulWidget {
  LoginViewModel viewModel;
  LoginWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: secondaryBack,
      width: width,
      child: Form(
        key: widget.viewModel.loginFormKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    r"assets\icon\logo_brand.png",
                    height: height * 0.22,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.08)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SFTextField(
                      controller: widget.viewModel.emailController,
                      labelText: "Digite seu e-mail",
                      prefixIcon: SvgPicture.asset(r"assets\icon\email.svg"),
                      pourpose: TextFieldPourpose.Email,
                      validator: emailValidator,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.025)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SFTextField(
                      controller: widget.viewModel.passwordController,
                      labelText: "Digite sua senha",
                      prefixIcon: SvgPicture.asset(r"assets\icon\lock.svg"),
                      suffixIcon:
                          SvgPicture.asset(r"assets\icon\eye_closed.svg"),
                      suffixIconPressed:
                          SvgPicture.asset(r"assets\icon\eye_open.svg"),
                      pourpose: TextFieldPourpose.Password,
                      validator: passwordValidator,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.01)),
                  InkWell(
                    onTap: () {
                      widget.viewModel.openForgotPasswordModal();
                    },
                    child: SizedBox(
                      height: height * 0.022,
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.1)),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      height: height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: SFButton(
                        buttonLabel: "Login",
                        onTap: () => widget.viewModel.login(context),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.1)),
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
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
