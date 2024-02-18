import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/Validators.dart';

import '../../../Menu/ViewModel/MenuProvider.dart';

class AddEmployeeWidget extends StatefulWidget {
  Function(String) onAdd;
  VoidCallback onReturn;
  AddEmployeeWidget({
    required this.onAdd,
    required this.onReturn,
  });

  @override
  State<AddEmployeeWidget> createState() => _AddEmployeeWidgetState();
}

class _AddEmployeeWidgetState extends State<AddEmployeeWidget> {
  final addEmployeeFormKey = GlobalKey<FormState>();
  TextEditingController addEmployeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        key: addEmployeeFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Adicionar funcionário",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Text(
                  "Insira o e-mail de um funcionário para adicionar à sua equipe. Ele receberá um e-mail com as próximas instruções",
                  style: TextStyle(color: textDarkGrey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            SFTextField(
              labelText: "Digite o e-mail do funcionário",
              pourpose: TextFieldPourpose.Email,
              controller: addEmployeeController,
              validator: emailValidator,
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
                    onTap: widget.onReturn,
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: SFButton(
                    buttonLabel: "Adicionar",
                    onTap: () {
                      if (addEmployeeFormKey.currentState?.validate() == true) {
                        widget.onAdd(addEmployeeController.text);
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
