import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/ViewModel/ProfileOverlayViewModel.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';

class Login extends StatelessWidget {
  VoidCallback onTapLogin;
  VoidCallback onTapLoginGoogle;
  Login({
    required this.onTapLogin,
    required this.onTapLoginGoogle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileOverlayViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SFTextField(
          controller: viewModel.emailController,
          labelText: "E-mail",
          prefixIcon: SvgPicture.asset(r"assets/icon/email.svg"),
          pourpose: TextFieldPourpose.Email,
          validator: emailValidator,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        SFTextField(
          controller: viewModel.passwordController,
          labelText: "Senha",
          prefixIcon: SvgPicture.asset(r"assets/icon/lock.svg"),
          suffixIcon: SvgPicture.asset(r"assets/icon/eye_closed.svg"),
          suffixIconPressed: SvgPicture.asset(r"assets/icon/eye_open.svg"),
          pourpose: TextFieldPourpose.Password,
          validator: passwordValidator,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () => viewModel.goToForgotMyPassword(),
            child: Text(
              "Esqueci minha senha",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: textBlue,
                decoration: TextDecoration.underline,
                decorationColor: textBlue,
              ),
            ),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        SFButton(
          buttonLabel: "Entrar",
          onTap: () => onTapLogin(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        // InkWell(
        //   onTap: () => onTapLoginGoogle(),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       SvgPicture.asset(
        //         r"assets/icon/google_logo.svg",
        //       ),
        //       SizedBox(
        //         width: defaultPadding / 2,
        //       ),
        //       Text(
        //         "Entrar com conta google",
        //         style: TextStyle(
        //           color: textDarkGrey,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: defaultPadding,
        // ),
        Container(
          height: 1,
          color: divider,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ainda não tem uma conta?',
                style: const TextStyle(
                  color: textDarkGrey,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: defaultPadding / 4,
              ),
              InkWell(
                onTap: () => viewModel.goToCreateAccount(),
                child: Text(
                  'Cadastre-se já!',
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: textBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
