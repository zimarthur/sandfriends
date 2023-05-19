import 'package:flutter/material.dart';

import '../../../../Utils/Constants.dart';
import '../../../../Utils/Validators.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../../../oldApp/widgets/SF_TextField.dart';
import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalHeight extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsModalHeight({
    required this.viewModel,
  });

  @override
  State<UserDetailsModalHeight> createState() => _UserDetailsModalHeightState();
}

class _UserDetailsModalHeightState extends State<UserDetailsModalHeight> {
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
        key: widget.viewModel.userDetailsHeightFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SFTextField(
              labelText: "Altura",
              pourpose: TextFieldPourpose.Numeric,
              controller: widget.viewModel.heightController,
              validator: heightValidator,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
            ),
            SFButton(
              buttonLabel: "Concluído",
              textPadding: EdgeInsets.symmetric(
                vertical: height * 0.02,
              ),
              onTap: () => widget.viewModel.setUserHeight(),
            )
          ],
        ),
      ),
    );
  }
}
