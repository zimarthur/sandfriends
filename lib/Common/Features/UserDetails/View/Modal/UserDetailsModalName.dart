import 'package:flutter/material.dart';

import '../../../../Components/SFButton.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';

import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalName extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsModalName({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsModalName> createState() => _UserDetailsModalNameState();
}

class _UserDetailsModalNameState extends State<UserDetailsModalName> {
  final userDetailsNameFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      child: Form(
        key: userDetailsNameFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SFTextField(
              labelText: "Nome",
              pourpose: TextFieldPourpose.Standard,
              controller: widget.viewModel.firstNameController,
              validator: nameValidator,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
            ),
            SFTextField(
              labelText: "Sobrenome",
              pourpose: TextFieldPourpose.Standard,
              controller: widget.viewModel.lastNameController,
              validator: lastNameValidator,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
            ),
            SFButton(
              buttonLabel: "Concluído",
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () {
                if (userDetailsNameFormKey.currentState?.validate() == true) {
                  widget.viewModel.setUserName(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
