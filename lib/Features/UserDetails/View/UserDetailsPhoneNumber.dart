import 'package:flutter/material.dart';

import '../../../SharedComponents/View/SFTextField.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/Validators.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsPhoneNumber extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsPhoneNumber({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsPhoneNumber> createState() => _UserDetailsPhoneNumberState();
}

class _UserDetailsPhoneNumberState extends State<UserDetailsPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Celular",
          style: TextStyle(
            color: textBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: defaultPadding / 4,
        ),
        Form(
          key: widget.viewModel.userDetailsPhoneNumberFormKey,
          child: SFTextField(
            controller: widget.viewModel.phoneNumberController,
            pourpose: TextFieldPourpose.Numeric,
            labelText: "",
            validator: phoneValidator,
            onChanged: (newNumber) =>
                widget.viewModel.onChangedPhoneNumber(newNumber),
          ),
        ),
        const SizedBox(
          height: defaultPadding / 8,
        ),
        const Text(
          "Nenhum jogador terá acesso ao seu celular",
          style: TextStyle(color: textDarkGrey),
          textScaleFactor: 0.8,
        ),
      ],
    );
  }
}
