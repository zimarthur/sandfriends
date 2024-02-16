import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/ViewModel/EmployeeInfoViewModel.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:sandfriends_web/Utils/Validators.dart';

import '../../../../Common/Components/SFButton.dart';

import '../../../Menu/ViewModel/MenuProvider.dart';

class RenameEmployeeWidget extends StatelessWidget {
  Function(String, String) onRename;
  VoidCallback onReturn;
  RenameEmployeeWidget({
    required this.onRename,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final renameEmployeeFormKey = GlobalKey<FormState>();
    TextEditingController renameFirstNameController = TextEditingController();
    TextEditingController renameLastNameController = TextEditingController();
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    return Container(
      width: width * 0.4 < 350 ? 350 : width * 0.4,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Form(
        key: renameEmployeeFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Altere seu nome",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            SFTextField(
              labelText: "Nome",
              pourpose: TextFieldPourpose.Standard,
              controller: renameFirstNameController,
              validator: (value) => emptyCheck(value, "Digite seu nome"),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            SFTextField(
              labelText: "Sobrenome",
              pourpose: TextFieldPourpose.Standard,
              controller: renameLastNameController,
              validator: (value) => emptyCheck(value, "Digite seu sobrenome"),
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            Row(
              children: [
                Expanded(
                  child: SFButton(
                    buttonLabel: "Voltar",
                    buttonType: ButtonType.Secondary,
                    onTap: onReturn,
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: SFButton(
                      buttonLabel: "Salvar",
                      buttonType: ButtonType.Primary,
                      onTap: () {
                        if (renameEmployeeFormKey.currentState?.validate() ==
                            true) {
                          onRename(renameFirstNameController.text,
                              renameLastNameController.text);
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
