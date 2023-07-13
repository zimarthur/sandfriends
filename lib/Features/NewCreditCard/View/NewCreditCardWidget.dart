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
      padding: EdgeInsets.all(defaultPadding),
      child: Form(
        key: widget.viewModel.newCreditCardFormKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SFTextField(
                    labelText: "Apelido do cartão (opcional)",
                    pourpose: TextFieldPourpose.Numeric,
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
                  Row(
                    children: [
                      Expanded(
                        child: SFTextField(
                          labelText: "CVV",
                          pourpose: TextFieldPourpose.Numeric,
                          controller: widget.viewModel.cardCvvController,
                          validator: (value) => validateCVV(value),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: SFTextField(
                          labelText: "Validade",
                          pourpose: TextFieldPourpose.Numeric,
                          controller:
                              widget.viewModel.cardExpirationDateController,
                          validator: (value) => validateCreditCardDate(value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SFTextField(
                    labelText: "Nome do titular",
                    pourpose: TextFieldPourpose.Numeric,
                    controller: widget.viewModel.cardOwnerController,
                    validator: (value) =>
                        emptyCheck(value, "Digite o nome do titular"),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SFTextField(
                    labelText: "CPF",
                    pourpose: TextFieldPourpose.Numeric,
                    controller: widget.viewModel.cardCpfController,
                    validator: (value) => cpfValidator(value),
                  ),
                ],
              ),
            ),
            SFButton(
              buttonLabel: "Adicionar cartão",
              onTap: () => widget.viewModel.addNewCreditCard(context),
              textPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
            )
          ],
        ),
      ),
    );
  }
}
