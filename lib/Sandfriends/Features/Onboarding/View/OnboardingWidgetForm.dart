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
  const OnboardingWidgetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingWidgetForm> createState() => _OnboardingWidgetFormState();
}

class _OnboardingWidgetFormState extends State<OnboardingWidgetForm> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Form(
        key: viewModel.onboardingFormKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: defaultPadding),
                    child: const Text(
                      "Pra começar, fale um pouco sobre você.",
                      style: TextStyle(
                          color: textBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          height: 1.4),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
                  if (viewModel.isEmailEmpty)
                    SFTextField(
                      controller: viewModel.emailController,
                      pourpose: TextFieldPourpose.Email,
                      labelText: "Email",
                      validator: emailValidator,
                    ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
                  SFTextField(
                    controller: viewModel.firstNameController,
                    pourpose: TextFieldPourpose.Standard,
                    labelText: "Nome",
                    validator: nameValidator,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
                  SFTextField(
                    controller: viewModel.lastNameController,
                    pourpose: TextFieldPourpose.Standard,
                    labelText: "Sobrenome",
                    validator: lastNameValidator,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
                  SFButton(
                    buttonLabel: viewModel.userSport == null
                        ? "Selecione seu esporte de preferência"
                        : viewModel.userSport!.description,
                    isPrimary: false,
                    onTap: () => viewModel.openSportSelectorModal(context),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
                  SFButton(
                    iconFirst: true,
                    buttonLabel: viewModel.userCity == null
                        ? "Selecione sua cidade"
                        : "${viewModel.userCity!.name} / ${viewModel.userCity!.state!.uf}",
                    isPrimary: false,
                    iconPath: r"assets/icon/location_ping.svg",
                    onTap: () {
                      viewModel.openCitySelectorModal(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultPadding / 2)),
                  InkWell(
                    onTap: () {
                      viewModel.termsAgreeValue = !viewModel.termsAgreeValue;
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: viewModel.termsAgreeValue,
                            activeColor: textBlue,
                            onChanged: (value) {
                              setState(() {
                                viewModel.termsAgreeValue = value!;
                              });
                            }),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'Eu li e concordo com os  ',
                              style: const TextStyle(color: textDarkGrey),
                              children: [
                                TextSpan(
                                    text: 'termos de uso',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(Uri.parse(termsUse));
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
                                        launchUrl(Uri.parse(privacyPolicy));
                                      }),
                                const TextSpan(text: "."),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  SFButton(
                    buttonLabel: "Começar",
                    color: viewModel.isFormValid ? primaryBlue : textDisabled,
                    onTap: () => viewModel.addUserInfo(context),
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
