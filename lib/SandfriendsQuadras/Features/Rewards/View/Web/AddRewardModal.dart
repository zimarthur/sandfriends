import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Responsive.dart';
import '../../../../../Common/Utils/Validators.dart';
import '../../ViewModel/RewardsViewModel.dart';

class AddRewardModal extends StatefulWidget {
  Function(String) onSendRewardCode;
  VoidCallback onReturn;
  AddRewardModal({
    required this.onSendRewardCode,
    required this.onReturn,
  });

  @override
  State<AddRewardModal> createState() => _AddRewardModalState();
}

class _AddRewardModalState extends State<AddRewardModal> {
  final addRewardFormKey = GlobalKey<FormState>();
  TextEditingController addRewardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      width: Responsive.isMobile(context) ? width * 0.9 : 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              key: addRewardFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Adicione uma nova recompensa",
                        style: TextStyle(color: textBlue, fontSize: 24),
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        "Digite o código do jogador para validar a recompensa",
                        style: TextStyle(color: textDarkGrey, fontSize: 16),
                      ),
                    ],
                  ),
                  SFTextField(
                      labelText: "",
                      pourpose: TextFieldPourpose.Standard,
                      controller: addRewardController,
                      validator: (a) =>
                          rewardCodeValidator(a, "Digite o código")),
                  Row(
                    children: [
                      Expanded(
                        child: SFButton(
                          buttonLabel: "Voltar",
                          isPrimary: false,
                          onTap: (() {
                            widget.onReturn();
                          }),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: SFButton(
                          buttonLabel: "Validar",
                          onTap: (() {
                            if (addRewardFormKey.currentState?.validate() ==
                                true) {
                              widget.onSendRewardCode(addRewardController.text);
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
