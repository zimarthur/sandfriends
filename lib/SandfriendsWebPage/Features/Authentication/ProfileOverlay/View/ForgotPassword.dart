import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/ViewModel/ProfileOverlayViewModel.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';

class ForgotPassword extends StatelessWidget {
  VoidCallback onTapForgotPassword;
  ForgotPassword({
    required this.onTapForgotPassword,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileOverlayViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SFTextField(
          controller: viewModel.emailForgotPasswordController,
          labelText: "E-mail",
          prefixIcon: SvgPicture.asset(r"assets/icon/email.svg"),
          pourpose: TextFieldPourpose.Email,
          validator: emailValidator,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        SFButton(
            buttonLabel: "Recuperar senha", onTap: () => onTapForgotPassword()),
      ],
    );
  }
}
