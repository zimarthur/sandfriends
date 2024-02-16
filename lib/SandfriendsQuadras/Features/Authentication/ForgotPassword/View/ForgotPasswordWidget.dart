import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Responsive.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../ViewModel/ForgotPasswordViewModel.dart';

class ForgotPasswordWidget extends StatefulWidget {
  ForgotPasswordViewModel viewModel;
  ForgotPasswordWidget({
    super.key,
    required this.viewModel,
  });

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(2 * defaultPadding),
      width: Responsive.isMobile(context)
          ? width * 0.9
          : width * 0.3 < 350
              ? 350
              : width * 0.3,
      height: height * 0.7,
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
            child: Form(
              key: widget.viewModel.forgotPasswordFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          r'assets/full_logo_positive_284.png',
                        ),
                      ),
                      InkWell(
                        onTap: () => widget.viewModel.goToLogin(context),
                        child: SvgPicture.asset(
                          r"assets/icon/arrow_left.svg",
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2 * defaultPadding,
                  ),
                  const Text(
                    "Informe seu e-mail",
                    style: TextStyle(color: textBlack, fontSize: 24),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const Text(
                    "Enviaremos um e-mail com um link para criar uma nova senha!",
                    style: TextStyle(color: textDarkGrey, fontSize: 16),
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  SFTextField(
                    labelText: "",
                    pourpose: TextFieldPourpose.Email,
                    controller: widget.viewModel.forgotPasswordEmailController,
                    validator: ((value) {
                      return emailValidator(value);
                    }),
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
                        if (widget.viewModel.forgotPasswordFormKey.currentState
                                ?.validate() ==
                            true) {
                          widget.viewModel.sendForgotPassword(context);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
