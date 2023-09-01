import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/NewCreditCard/ViewModel/NewCreditCardViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/SharedComponents/View/SFTextField.dart';
import 'package:sandfriends/Utils/Validators.dart';

import '../../../SharedComponents/Model/CreditCard/CreditCardUtils.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';

class NewCreditCardWidget extends StatefulWidget {
  NewCreditCardViewModel viewModel;
  NewCreditCardWidget({
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
      margin: EdgeInsets.all(defaultPadding),
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
                        validator: (value) {},
                      ),
                      SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Container(
                        color: divider,
                        height: 1,
                      ),
                      SizedBox(
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
                      SizedBox(
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
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Nome do titular",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardOwnerController,
                        validator: (value) =>
                            emptyCheck(value, "digite o nome do titular"),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "CPF",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.cardCpfController,
                        validator: (value) =>
                            cpfValidator(value, "digite o cpf do titular"),
                      ),
                      SizedBox(
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
                      SizedBox(
                        height: defaultPadding * 3,
                      ),
                      Text("Endereço dos pagamentos"),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "CEP",
                        pourpose: TextFieldPourpose.Numeric,
                        controller: widget.viewModel.cardCepController,
                        validator: (value) => cepValidator(value),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      SFTextField(
                        labelText: "Cidade",
                        pourpose: TextFieldPourpose.Standard,
                        controller: widget.viewModel.cardCityController,
                        validator: (value) =>
                            emptyCheck(value, "digite a cidade"),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SFTextField(
                              labelText: "Endereço",
                              pourpose: TextFieldPourpose.Standard,
                              controller:
                                  widget.viewModel.cardAddressController,
                              validator: (value) =>
                                  emptyCheck(value, "digite o endereço"),
                            ),
                          ),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          Expanded(
                            flex: 1,
                            child: SFTextField(
                              labelText: "Nº",
                              pourpose: TextFieldPourpose.Standard,
                              controller:
                                  widget.viewModel.cardAddressNumberController,
                              validator: (value) =>
                                  emptyCheck(value, "digite o nº"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            r"assets/icon/security.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Flexible(
                            child: Text(
                              "Todos os seus dados são criptografados.",
                              style: TextStyle(color: textDarkGrey),
                              textScaleFactor: 0.9,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
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
              textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            )
          ],
        ),
      ),
    );
  }
}
