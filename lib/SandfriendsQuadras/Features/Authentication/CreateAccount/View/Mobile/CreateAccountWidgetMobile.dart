import 'package:flutter/material.dart';

import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../../SharedComponents/View/SFButton.dart';
import '../../ViewModel/CreateAccountViewModel.dart';
import 'CreateAccountCourtWidgetMobile.dart';
import 'CreateAccountOwnerWidgetMobile.dart';

class CreateAccountWidgetMobile extends StatefulWidget {
  CreateAccountCourtViewModel viewModel;
  CreateAccountWidgetMobile({
    super.key,
    required this.viewModel,
  });

  @override
  State<CreateAccountWidgetMobile> createState() =>
      _CreateAccountWidgetMobileState();
}

class _CreateAccountWidgetMobileState extends State<CreateAccountWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2 * defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      width: width * 0.9,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: widget.viewModel.currentCreateAccountFormIndex == 0
                ? CreateAccountCourtWidgetMobile(
                    viewModel: widget.viewModel,
                  )
                : CreateAccountOwnerWidgetMobile(
                    viewModel: widget.viewModel,
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                    buttonLabel: "Voltar",
                    onTap: () {
                      widget.viewModel.returnForm(context);
                    }),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                    buttonLabel:
                        widget.viewModel.currentCreateAccountFormIndex == 0
                            ? "Próximo"
                            : "Finalizar",
                    color: widget.viewModel.buttonNextEnabled
                        ? primaryBlue
                        : disabled,
                    onTap: () {
                      widget.viewModel.nextForm(context);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
