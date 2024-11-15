import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../ViewModel/LoginViewModel.dart';

class ForgotPasswordModal extends StatefulWidget {
  final LoginViewModel viewModel;
  const ForgotPasswordModal({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final forgotPasswordFormKeyApp = GlobalKey<FormState>();

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
              r"assets/icon/happy_face.svg",
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
              key: forgotPasswordFormKeyApp,
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
                  onTap: () {
                    if (forgotPasswordFormKeyApp.currentState?.validate() ==
                        true) {
                      widget.viewModel.requestForgotPassword(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
