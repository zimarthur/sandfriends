import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCard.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../Common/Components/CreditCard/CreditCardCard.dart';
import '../../../../Common/Model/School/School.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFImage.dart';
import '../../Menu/ViewModel/StoreProvider.dart';

class AddTeacherModal extends StatefulWidget {
  Function(String) onAdd;
  VoidCallback onReturn;
  AddTeacherModal({
    required this.onAdd,
    required this.onReturn,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTeacherModal> createState() => _AddTeacherModalState();
}

class _AddTeacherModalState extends State<AddTeacherModal> {
  final addTeacherFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: divider, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: divider)],
      ),
      width: width * 0.3 > 400 ? 400 : width * 0.3,
      child: Form(
        key: addTeacherFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => widget.onReturn(),
                child: SvgPicture.asset(
                  r"assets/icon/x.svg",
                  color: textDarkGrey,
                ),
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  r"assets/icon/class_add.svg",
                  height: 30,
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Text(
                  "Adicionar professor(a)",
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Insira o e-mail do professor(a)",
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            SFTextField(
              labelText: "",
              pourpose: TextFieldPourpose.Email,
              controller: emailController,
              validator: (value) => emailValidator(
                value,
                onEmpty: "Digite o e-mail",
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SFButton(
                buttonLabel: "Adicionar",
                onTap: () {
                  if (addTeacherFormKey.currentState?.validate() == true) {
                    widget.onAdd(emailController.text);
                  }
                })
          ],
        ),
      ),
    );
  }
}
