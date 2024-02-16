import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../../Common/Utils/Validators.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../ViewModel/CreateAccountViewModel.dart';

class CreateAccountOwnerWidgetWeb extends StatefulWidget {
  CreateAccountCourtViewModel viewModel;
  CreateAccountOwnerWidgetWeb({
    super.key,
    required this.viewModel,
  });

  @override
  State<CreateAccountOwnerWidgetWeb> createState() =>
      _CreateAccountOwnerWidgetWebState();
}

class _CreateAccountOwnerWidgetWebState
    extends State<CreateAccountOwnerWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: widget.viewModel.ownerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gestor, conte-nos mais sobre você",
                      style: TextStyle(color: textBlack, fontSize: 24),
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SFTextField(
                            labelText: "Nome",
                            pourpose: TextFieldPourpose.Standard,
                            controller:
                                widget.viewModel.ownerFirstNameController,
                            validator: (value) =>
                                lettersValidator(value, "Digite seu nome"),
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: SFTextField(
                            labelText: "Sobrenome",
                            pourpose: TextFieldPourpose.Standard,
                            controller:
                                widget.viewModel.ownerLastNameController,
                            validator: (value) =>
                                lettersValidator(value, "Digite seu sobrenome"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    !widget.viewModel.noCnpj
                        ? Column(
                            children: [
                              SFTextField(
                                labelText: "CPF",
                                pourpose: TextFieldPourpose.Standard,
                                controller: widget.viewModel.cpfController,
                                validator: (value) => cpfValidator(
                                  value,
                                  null,
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                            ],
                          )
                        : Container(),
                    SFTextField(
                      labelText: "Email",
                      pourpose: TextFieldPourpose.Standard,
                      controller: widget.viewModel.emailController,
                      validator: (value) => emailValidator(value),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SFTextField(
                            controller: widget.viewModel.passwordController,
                            labelText: "Senha",
                            suffixIcon:
                                SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                            suffixIconPressed:
                                SvgPicture.asset(r"assets/icon/eye_open.svg"),
                            pourpose: TextFieldPourpose.Password,
                            validator: (value) {
                              return passwordValidator(value);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: SFTextField(
                            controller:
                                widget.viewModel.confirmPasswordController,
                            labelText: "Confirme sua senha",
                            suffixIcon:
                                SvgPicture.asset(r"assets/icon/eye_closed.svg"),
                            suffixIconPressed:
                                SvgPicture.asset(r"assets/icon/eye_open.svg"),
                            pourpose: TextFieldPourpose.Password,
                            validator: (value) {
                              return confirmPasswordValidator(
                                value,
                                widget.viewModel.passwordController.text,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SFTextField(
                            labelText: "Telefone do Estabelecimento",
                            pourpose: TextFieldPourpose.Numeric,
                            controller: widget.viewModel.telephoneController,
                            validator: (value) => phoneNumberValidator(value),
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: SFTextField(
                            labelText: "Telefone Pessoal",
                            pourpose: TextFieldPourpose.Numeric,
                            controller:
                                widget.viewModel.telephoneOwnerController,
                            validator: (_) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: primaryBlue,
                          value: widget.viewModel.isAbove18,
                          onChanged: (value) =>
                              widget.viewModel.isAbove18 = value!,
                        ),
                        RichText(
                          text: const TextSpan(
                            text: 'Declaro que tenho acima de 18 anos',
                            style: TextStyle(
                              color: textDarkGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: primaryBlue,
                          value: widget.viewModel.termsAgree,
                          onChanged: (value) =>
                              widget.viewModel.termsAgree = value!,
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'Li e concordo com os ',
                              style: const TextStyle(
                                color: textDarkGrey,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Termos de Uso ',
                                  style: const TextStyle(
                                      color: textBlue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.viewModel
                                          .onTapTermosDeUso(context);
                                    },
                                ),
                                const TextSpan(
                                  text: 'e ',
                                ),
                                TextSpan(
                                  text: 'Política de Privacidade',
                                  style: const TextStyle(
                                      color: textBlue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.viewModel
                                          .onTapPoliticaDePrivacidade(context);
                                    },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
