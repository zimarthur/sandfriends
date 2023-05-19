import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../../../oldApp/widgets/SF_TextField.dart';
import '../ViewModel/LoginViewModel.dart';

class ForgotPasswordModal extends StatefulWidget {
  LoginViewModel viewModel;
  ForgotPasswordModal({
    required this.viewModel,
  });

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: primaryDarkBlue,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            color: primaryDarkBlue,
          )
        ],
      ),
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.1, vertical: height * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              r"assets\icon\happy_face.svg",
              height: width * 0.25,
              width: width * 0.25,
            ),
            Container(
              constraints: BoxConstraints(minHeight: height * 0.1),
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(top: height * 0.05, bottom: height * 0.02),
              child: const Text(
                "Digite seu e-mail e enviaremos o link para troca de senha",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Form(
              key: widget.viewModel.forgotPasswordFormKey,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: SFTextField(
                  labelText: "digite seu e-mail",
                  pourpose: TextFieldPourpose.Email,
                  controller: widget.viewModel.forgotPasswordEmailController,
                  validator: emailValidator,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: SizedBox(
                height: height * 0.05,
                child: SFButton(
                  buttonLabel: "Enviar",
                  onTap: () => widget.viewModel.requestForgotPassword(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
