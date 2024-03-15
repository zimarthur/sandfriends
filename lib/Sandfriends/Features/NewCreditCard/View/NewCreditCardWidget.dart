import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/ViewModel/NewCreditCardViewModel.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../Common/Model/CreditCard/CreditCardUtils.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/Utils/Constants.dart';

class NewCreditCardWidget extends StatefulWidget {
  final NewCreditCardViewModel viewModel;
  const NewCreditCardWidget({
    super.key,
    required this.viewModel,
  });

  @override
  State<NewCreditCardWidget> createState() => _NewCreditCardWidgetState();
}

class _NewCreditCardWidgetState extends State<NewCreditCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      margin: const EdgeInsets.all(defaultPadding),
      child: Form(
        key: widget.viewModel.newCreditCardFormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SFTextField(
                        labelText: "Apelido do cartão (opcional)",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardNicknameController,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Container(
                        color: divider,
                        height: 1,
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Número do cartão",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.cardNumberController,
                        validator: (value) => validateCardNum(value),
                        suffixIcon: SvgPicture.asset(
                          creditCardImagePath(widget.viewModel.cardType),
                          height: 20,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Validade",
                        pourpose: TextFieldPourpose.Numeric,
                        hintText: "MM/AAAA",
                        controller:
                            widget.viewModel.cardExpirationDateController,
                        validator: (value) => validateCreditCardDate(value),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Nome do titular",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardOwnerController,
                        validator: (value) =>
                            emptyCheck(value, "digite o nome do titular"),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "CPF",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.cardCpfController,
                        validator: (value) =>
                            cpfValidator(value, "digite o cpf do titular"),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Celular",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.phoneNumberController,
                        validator: (value) => phoneValidator(
                          value,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding * 3,
                      ),
                      const Text("Endereço dos pagamentos"),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "CEP",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.cardCepController,
                        validator: (value) => cepValidator(value),
                        onChanged: (value) =>
                            widget.viewModel.onCepChanged(context),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Cidade",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardCityController,
                        validator: (value) =>
                            emptyCheck(value, "digite a cidade"),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Endereço",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardAddressController,
                        validator: (value) =>
                            emptyCheck(value, "digite o endereço"),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SFTextField(
                              labelText: "N°",
                              pourpose: TextFieldPourpose.Standard,
                              controller:
                                  widget.viewModel.cardAddressNumberController,
                              validator: (value) =>
                                  emptyCheck(value, "digite o nº"),
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Expanded(
                            child: SFTextField(
                              labelText: "Complemento",
                              pourpose: TextFieldPourpose.Standard,
                              controller: widget
                                  .viewModel.cardAddressComplementController,
                              validator: (value) =>
                                  emptyCheck(value, "digite o complemento"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            r"assets/icon/security.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                          const SizedBox(
                            width: defaultPadding / 2,
                          ),
                          const Flexible(
                            child: Text(
                              "Todos os seus dados são criptografados.",
                              style: TextStyle(color: textDarkGrey),
                              textScaleFactor: 0.9,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2 * defaultPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SFButton(
              buttonLabel: "Adicionar cartão",
              onTap: () => widget.viewModel.addNewCreditCard(context),
              textPadding:
                  const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            ),
          ],
        ),
      ),
    );
  }
}
