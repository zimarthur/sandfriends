import 'package:flutter/material.dart';
import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

class UserDetailsEmail extends StatelessWidget {
  UserDetailsViewModel viewModel;
  UserDetailsEmail({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(
              color: textBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: defaultPadding / 4,
          ),
          Text(
            viewModel.userEdited.email,
            style: const TextStyle(
              color: textBlue,
            ),
          ),
        ],
      ),
    );
  }
}
