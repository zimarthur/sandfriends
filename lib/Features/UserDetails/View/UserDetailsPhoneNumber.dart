import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';
import '../../../Utils/Validators.dart';
import '../../../oldApp/widgets/SF_TextField.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsPhoneNumber extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsPhoneNumber({
    required this.viewModel,
  });

  @override
  State<UserDetailsPhoneNumber> createState() => _UserDetailsPhoneNumberState();
}

class _UserDetailsPhoneNumberState extends State<UserDetailsPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutConstraints) {
        double width = layoutConstraints.maxWidth;
        double height = layoutConstraints.maxHeight;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Celular",
              style: TextStyle(
                color: textBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: defaultPadding / 4,
            ),
            Form(
              key: widget.viewModel.userDetailsPhoneNumberFormKey,
              child: SFTextField(
                controller: widget.viewModel.phoneNumberController,
                pourpose: TextFieldPourpose.Numeric,
                labelText: "",
                validator: phoneValidator,
              ),
            ),
            SizedBox(
              height: defaultPadding / 8,
            ),
            Text(
              "Nenhum jogador terá acesso ao seu celular",
              style: TextStyle(color: textDarkGrey),
              textScaleFactor: 0.8,
            ),
          ],
        );
      },
    );
  }
}
