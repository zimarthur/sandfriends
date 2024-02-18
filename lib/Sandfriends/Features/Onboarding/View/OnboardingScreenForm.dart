import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Components/SFTextField.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/Validators.dart';

import '../ViewModel/OnboardingViewModel.dart';

class OnboardingWidgetForm extends StatefulWidget {
  final OnboardingViewModel viewModel;
  const OnboardingWidgetForm({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<OnboardingWidgetForm> createState() => _OnboardingWidgetFormState();
}

class _OnboardingWidgetFormState extends State<OnboardingWidgetForm> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => widget.viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            titleText: "Meu perfil",
            appBarType: AppBarType.Secondary,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              color: secondaryBack,
              width: double.infinity,
              child: Form(
                key: widget.viewModel.onboardingFormKey,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.02),
                            child: const Text(
                              "Pra começar, fale um pouco sobre você.",
                              style: TextStyle(
                                  color: textBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  height: 1.4),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.04)),
                          if (widget.viewModel.isEmailEmpty)
                            SFTextField(
                              controller: widget.viewModel.emailController,
                              pourpose: TextFieldPourpose.Email,
                              labelText: "Email",
                              validator: emailValidator,
                            ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          SFTextField(
                            controller: widget.viewModel.firstNameController,
                            pourpose: TextFieldPourpose.Standard,
                            labelText: "Nome",
                            validator: nameValidator,
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          SFTextField(
                            controller: widget.viewModel.lastNameController,
                            pourpose: TextFieldPourpose.Standard,
                            labelText: "Sobrenome",
                            validator: lastNameValidator,
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          SFButton(
                            textPadding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            buttonLabel: widget.viewModel.userSport == null
                                ? "Selecione seu esporte de preferência"
                                : widget.viewModel.userSport!.description,
                            isPrimary: false,
                            onTap: () => widget.viewModel
                                .openSportSelectorModal(context),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          SFButton(
                            iconFirst: true,
                            textPadding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            buttonLabel: widget.viewModel.userCity == null
                                ? "Selecione sua cidade"
                                : "${widget.viewModel.userCity!.name} / ${widget.viewModel.userCity!.state!.uf}",
                            isPrimary: false,
                            iconPath: r"assets/icon/location_ping.svg",
                            onTap: () {
                              widget.viewModel.openCitySelectorModal(context);
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: height * 0.03)),
                          InkWell(
                            onTap: () {
                              widget.viewModel.termsAgreeValue =
                                  !widget.viewModel.termsAgreeValue;
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                    value: widget.viewModel.termsAgreeValue,
                                    activeColor: textBlue,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.viewModel.termsAgreeValue =
                                            value!;
                                      });
                                    }),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Eu li e concordo com os  ',
                                      style:
                                          const TextStyle(color: textDarkGrey),
                                      children: [
                                        TextSpan(
                                            text: 'termos de uso',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textBlue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launchUrl(Uri.parse(
                                                    "https://www.sandfriends.com.br/termos"));
                                              }),
                                        const TextSpan(text: " e a "),
                                        TextSpan(
                                            text: 'política de privacidade',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textBlue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launchUrl(Uri.parse(
                                                    "https://www.sandfriends.com.br/politicaprivacidade"));
                                              }),
                                        const TextSpan(text: "."),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                height: height * 0.05,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.14),
                                child: SFButton(
                                  buttonLabel: "Começar",
                                  color: widget.viewModel.isFormValid
                                      ? primaryBlue
                                      : textDisabled,
                                  onTap: () =>
                                      widget.viewModel.addUserInfo(context),
                                ),
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
            ),
          );
        },
      ),
    );
  }
}
