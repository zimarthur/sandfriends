import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';

import '../ViewModel/CreateAccountViewModel.dart';

class CreateAccountWidget extends StatefulWidget {
  final CreateAccountViewModel viewModel;
  const CreateAccountWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: secondaryBack,
      width: double.infinity,
      child: Form(
        key: widget.viewModel.createAccountFormKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Provider.of<EnvironmentProvider>(context,
                                      listen: false)
                                  .environment
                                  .isSandfriendsAulas
                              ? r"assets/logo_brand_aulas.png"
                              : r"assets/logo_brand.png",
                          height: height * 0.22,
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: height * 0.08)),
                        SFTextField(
                          controller: widget.viewModel.emailController,
                          labelText: "Email",
                          prefixIcon:
                              SvgPicture.asset(r"assets/icon/email.svg"),
                          pourpose: TextFieldPourpose.Email,
                          validator: emailValidator,
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: height * 0.025)),
                        SFTextField(
                          controller: widget.viewModel.passwordController,
                          labelText: "Senha",
                          prefixIcon: SvgPicture.asset(r"assets/icon/lock.svg"),
                          suffixIcon:
                              SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                          suffixIconPressed:
                              SvgPicture.asset(r"assets/icon/eye_open.svg"),
                          pourpose: TextFieldPourpose.Password,
                          validator: passwordValidator,
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: height * 0.025)),
                        SFTextField(
                          controller:
                              widget.viewModel.confirmPasswordController,
                          labelText: "Confirme sua senha",
                          prefixIcon: SvgPicture.asset(r"assets/icon/lock.svg"),
                          suffixIcon:
                              SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                          suffixIconPressed:
                              SvgPicture.asset(r"assets/icon/eye_open.svg"),
                          pourpose: TextFieldPourpose.Password,
                          validator: (value) {
                            return confirmPasswordValidator(value,
                                widget.viewModel.passwordController.text);
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: height * 0.13)),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: height * 0.05,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.14),
                            child: SFButton(
                                buttonLabel: "Criar Conta",
                                onTap: () =>
                                    widget.viewModel.createAccount(context)),
                          ),
                        ),
                      ],
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
                        r'assets/icon/sand_bar.svg',
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
