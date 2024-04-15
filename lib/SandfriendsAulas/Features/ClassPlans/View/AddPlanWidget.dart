import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassFormatPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassFrequencyPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/ViewModel/ClassPlansScreenViewModel.dart';

import '../../../../Common/Utils/Constants.dart';

class AddPlanWidget extends StatefulWidget {
  ClassPlansScreenAulasViewModel viewModel;
  AddPlanWidget({required this.viewModel, super.key});

  @override
  State<AddPlanWidget> createState() => _AddPlanWidgetState();
}

class _AddPlanWidgetState extends State<AddPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return AnimatedOpacity(
        duration: Duration(
            milliseconds: widget.viewModel.currentPlan != null ? 350 : 50),
        opacity: widget.viewModel.currentPlan != null ? 1 : 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: layoutConstraints.maxWidth,
          height: widget.viewModel.currentPlan != null ? 350 : 0,
          decoration: BoxDecoration(
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            border: Border.all(color: primaryBlue, width: 2),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => widget.viewModel.closeAddPlan(),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      defaultPadding,
                    ),
                    child: SvgPicture.asset(
                      r"assets/icon/x.svg",
                      color: textDarkGrey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.viewModel.isEditingPlan
                            ? "Editar plano"
                            : "Novo plano",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Formato da aula",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClassFormatPopUp(
                                  currentFormat:
                                      widget.viewModel.currentPlan?.format,
                                  onSelectedFormat: (format) =>
                                      widget.viewModel.setClassFormat(format),
                                  enabled: !widget.viewModel.isEditingPlan,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Frequência semana",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClassFrequencyPopUp(
                                  currentClassFrequency: widget
                                      .viewModel.currentPlan?.classFrequency,
                                  onSelectedFrequency: (freq) =>
                                      widget.viewModel.setClassFrequency(freq),
                                  enabled: !widget.viewModel.isEditingPlan,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Preço por aula",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SFTextField(
                                  labelText: "",
                                  pourpose: TextFieldPourpose.Numeric,
                                  controller: widget.viewModel.priceController,
                                  sufixText: " /aula",
                                  prefixText: r"R$",
                                  textAlign: TextAlign.center,
                                  validator: (a) {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: defaultPadding),
                        child: SFButton(
                            buttonLabel: widget.viewModel.isEditingPlan
                                ? "Salvar plano"
                                : "Adicionar plano",
                            onTap: () => widget.viewModel.savePlan(context)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
