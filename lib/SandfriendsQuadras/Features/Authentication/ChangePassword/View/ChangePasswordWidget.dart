import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../ViewModel/ChangePasswordViewModel.dart';

class ChangePasswordWidget extends StatefulWidget {
  ChangePasswordViewModel viewModel;
  ChangePasswordWidget({
    required this.viewModel,
  });

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(2 * defaultPadding),
      width: width * 0.4 < 350 ? 350 : width * 0.4,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Form(
        key: widget.viewModel.changePasswordFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  r'assets/full_logo_positive_284.png',
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                "Troque sua senha",
                style: TextStyle(color: textBlack, fontSize: 24),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                "Redefina sua senha para continuar usando Sandfriends.",
                style: TextStyle(color: textDarkGrey, fontSize: 16),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              SFTextField(
                controller: widget.viewModel.newPasswordController,
                labelText: "Senha",
                suffixIcon: SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                suffixIconPressed:
                    SvgPicture.asset(r"assets/icon/eye_open.svg"),
                pourpose: TextFieldPourpose.Password,
                validator: (value) {
                  return passwordValidator(value);
                },
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              SFTextField(
                controller: widget.viewModel.confirmNewPasswordController,
                labelText: "Confirme sua senha",
                suffixIcon: SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                suffixIconPressed:
                    SvgPicture.asset(r"assets/icon/eye_open.svg"),
                pourpose: TextFieldPourpose.Password,
                validator: (value) => confirmPasswordValidator(
                  value,
                  widget.viewModel.newPasswordController.text,
                ),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.3 < 350 ? 35 : width * 0.03),
                child: SFButton(
                  buttonLabel: "Enviar",
                  onTap: () {
                    if (widget.viewModel.changePasswordFormKey.currentState
                            ?.validate() ==
                        true) {
                      widget.viewModel.changePassword(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
