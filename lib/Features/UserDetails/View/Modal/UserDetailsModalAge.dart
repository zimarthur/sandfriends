import 'package:flutter/material.dart';
import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';

import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../../../oldApp/widgets/SF_TextField.dart';

class UserDetailsModalAge extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsModalAge({
    required this.viewModel,
  });

  @override
  State<UserDetailsModalAge> createState() => _UserDetailsModalAgeState();
}

class _UserDetailsModalAgeState extends State<UserDetailsModalAge> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      child: Form(
        key: widget.viewModel.userDetailsAgeFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SFTextField(
              labelText: "Aniversário",
              pourpose: TextFieldPourpose.Numeric,
              controller: widget.viewModel.birthdayController,
              validator: birthdayValidator,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                "A sua idade será categorizada em faixas de idade. Ninguém terá acesso à sua idade exata.",
                style: TextStyle(color: textDarkGrey),
                textScaleFactor: 0.8,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
            ),
            SFButton(
              buttonLabel: "Concluído",
              buttonType: ButtonType.Primary,
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () => widget.viewModel.setUserAge(),
            )
          ],
        ),
      ),
    );
  }
}
