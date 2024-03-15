import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../ViewModel/ProfileOverlayViewModel.dart';

final createAccountFormKey = GlobalKey<FormState>();

class Signup extends StatelessWidget {
  VoidCallback onTapCreateAccount;
  Signup({
    required this.onTapCreateAccount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileOverlayViewModel>(context);
    return Form(
      key: createAccountFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SFTextField(
            controller: viewModel.emailCreateAccountController,
            labelText: "E-mail",
            prefixIcon: SvgPicture.asset(r"assets/icon/email.svg"),
            pourpose: TextFieldPourpose.Email,
            validator: emailValidator,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          SFTextField(
            controller: viewModel.passwordCreateAccountController,
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
          SFTextField(
            controller: viewModel.passwordVerificationCreateAccountController,
            labelText: "Confirme sua senha",
            prefixIcon: SvgPicture.asset(r"assets/icon/lock.svg"),
            suffixIcon: SvgPicture.asset(r"assets/icon/eye_closed.svg"),
            suffixIconPressed: SvgPicture.asset(r"assets/icon/eye_open.svg"),
            pourpose: TextFieldPourpose.Password,
            validator: passwordValidator,
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SFButton(
            buttonLabel: "Criar conta",
            onTap: () {
              if (createAccountFormKey.currentState?.validate() == true) {
                onTapCreateAccount();
              }
            },
          ),
        ],
      ),
    );
  }
}
