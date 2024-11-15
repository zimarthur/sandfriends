import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';

import '../../../Menu/ViewModel/MenuProviderQuadras.dart';

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
    double width =
        Provider.of<MenuProviderQuadras>(context).getScreenWidth(context);
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
                    isPrimary: false,
                    onTap: onReturn,
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: SFButton(
                      buttonLabel: "Salvar",
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
