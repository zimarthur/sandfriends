import 'package:flutter/material.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../../Common/Utils/Validators.dart';
import '../../ViewModel/CreateAccountViewModel.dart';

class CreateAccountCourtWidgetMobile extends StatefulWidget {
  CreateAccountCourtViewModel viewModel;
  CreateAccountCourtWidgetMobile({
    super.key,
    required this.viewModel,
  });

  @override
  State<CreateAccountCourtWidgetMobile> createState() =>
      _CreateAccountCourtWidgetMobileState();
}

class _CreateAccountCourtWidgetMobileState
    extends State<CreateAccountCourtWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Form(
            key: widget.viewModel.courtFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cadastre seu estabelecimento!",
                      style: TextStyle(color: textBlack, fontSize: 24),
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Text(
                      "Você está a poucos cliques de gerenciar suas quadras com sandfriends!",
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding * 2,
                ),
                Column(
                  children: [
                    SFTextField(
                      labelText: widget.viewModel.noCnpj ? "CPF" : "CNPJ",
                      pourpose: TextFieldPourpose.Numeric,
                      controller: widget.viewModel.noCnpj
                          ? widget.viewModel.cpfController
                          : widget.viewModel.cnpjController,
                      validator: (value) {
                        if (widget.viewModel.noCnpj) {
                          return cpfValidator(value, null);
                        } else {
                          return cnpjValidator(value);
                        }
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: primaryBlue,
                            value: widget.viewModel.noCnpj,
                            onChanged: (value) {
                              setState(() {
                                widget.viewModel.noCnpj = value!;
                              });
                            }),
                        const Text(
                          "Não tenho CNPJ",
                          style: TextStyle(color: textDarkGrey),
                        ),
                      ],
                    ),
                    widget.viewModel.noCnpj
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              SFButton(
                                buttonLabel: "Buscar",
                                textPadding: const EdgeInsets.symmetric(
                                    horizontal: 2 * defaultPadding,
                                    vertical: defaultPadding),
                                onTap: () {
                                  widget.viewModel.onTapSearchCnpj(context);
                                },
                              ),
                            ],
                          ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                  width: double.infinity,
                  height: 1,
                  color: divider,
                ),
                SFTextField(
                  labelText: "Nome do Estabelecimento",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.storeNameController,
                  validator: (value) => emptyCheck(
                    value,
                    "Digite o nome do estabelecimento",
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "CEP",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.cepController,
                  validator: (value) => cepValidator(value),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "Estado (UF)",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.stateController,
                  validator: (value) => lettersValidator(
                    value,
                    "Digite o estado",
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "Cidade",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.cityController,
                  validator: (value) => emptyCheck(
                    value,
                    "Digite a cidade",
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "Bairro",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.neighbourhoodController,
                  validator: (value) => emptyCheck(
                    value,
                    "Digite o bairro",
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "Rua",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.addressController,
                  validator: (value) => emptyCheck(
                    value,
                    "Digite a rua",
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                SFTextField(
                  labelText: "Nº",
                  pourpose: TextFieldPourpose.Standard,
                  controller: widget.viewModel.addressNumberController,
                  validator: (value) => emptyCheck(
                    value,
                    "Digite o número",
                  ),
                ),
                const SizedBox(
                  height: 2 * defaultPadding,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
