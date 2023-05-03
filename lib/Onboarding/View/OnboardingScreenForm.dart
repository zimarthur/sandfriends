import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Onboarding/ViewModel/OnboardingViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/Utils/validators.dart';

import '../../SharedComponents/View/SFStandardScreen.dart';
import '../../oldApp/models/enums.dart';
import '../../oldApp/widgets/SF_Button.dart';
import '../../oldApp/widgets/SF_TextField.dart';

class OnboardingWidgetForm extends StatefulWidget {
  OnboardingViewModel viewModel;
  OnboardingWidgetForm({
    required this.viewModel,
  });

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
          return SFStandardScreen(
            titleText: widget.viewModel.titleTextForm,
            onTapReturn: () => widget.viewModel.goToLoginSignup(context),
            onTapBackground: () => widget.viewModel.closeModal(),
            messageModalWidget: widget.viewModel.modalMessage,
            modalFormWidget: widget.viewModel.widgetForm,
            pageStatus: widget.viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              color: secondaryBack,
              width: double.infinity,
              child: Form(
                key: widget.viewModel.onboardingFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Text(
                        "Pra começar, fale um pouco sobre você.",
                        style: TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            height: 1.4),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.04)),
                    SFTextField(
                      controller: widget.viewModel.firstNameController,
                      pourpose: TextFieldPourpose.Standard,
                      labelText: "Nome",
                      validator: nameValidator,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    SFTextField(
                      controller: widget.viewModel.lastNameController,
                      pourpose: TextFieldPourpose.Standard,
                      labelText: "Sobrenome",
                      validator: lastNameValidator,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    SFTextField(
                      controller: widget.viewModel.phoneNumberController,
                      pourpose: TextFieldPourpose.Numeric,
                      labelText: "Celular",
                      validator: phoneValidator,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    SFButton(
                      textPadding:
                          EdgeInsets.symmetric(vertical: height * 0.01),
                      buttonLabel: widget.viewModel.userSport == null
                          ? "Selecione seu esporte de preferência"
                          : widget.viewModel.userSport!.description,
                      buttonType: ButtonType.Secondary,
                      onTap: () =>
                          widget.viewModel.openSportSelectorModal(context),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    SFButton(
                      iconFirst: true,
                      textPadding:
                          EdgeInsets.symmetric(vertical: height * 0.01),
                      buttonLabel: widget.viewModel.userRegion == null
                          ? "Selecione sua cidade"
                          : "${widget.viewModel.userRegion!.selectedCity!.city} / ${widget.viewModel.userRegion!.uf}",
                      buttonType: ButtonType.Secondary,
                      iconPath: r"assets\icon\location_ping.svg",
                      onTap: () {
                        widget.viewModel.openCitySelectorModal(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    InkWell(
                      onTap: () {
                        widget.viewModel.termsAgreeValue =
                            !widget.viewModel.termsAgreeValue;
                      },
                      child: Row(
                        children: [
                          Checkbox(
                              value: widget.viewModel.termsAgreeValue,
                              fillColor:
                                  MaterialStateProperty.all<Color>(primaryBlue),
                              onChanged: (value) {
                                setState(() {
                                  widget.viewModel.termsAgreeValue = value!;
                                });
                              }),
                          RichText(
                            text: TextSpan(
                              text: 'Eu li e concordo com os  ',
                              style: TextStyle(color: textDarkGrey),
                              children: [
                                TextSpan(
                                    text: 'termos de uso',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print('Terms of Service"');
                                      }),
                                const TextSpan(text: "."),
                              ],
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
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.14),
                          child: SFButton(
                            buttonLabel: "Começar",
                            buttonType: widget.viewModel.isFormValid
                                ? ButtonType.Primary
                                : ButtonType.Disabled,
                            onTap: () {
                              if (widget.viewModel.isFormValid) {
                                if (widget.viewModel.onboardingFormKey
                                        .currentState
                                        ?.validate() ==
                                    true) {
                                  // addUserInfo(context);
                                }
                              }
                            },
                          ),
                        ),
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
