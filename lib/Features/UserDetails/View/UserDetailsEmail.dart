import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsEmail extends StatelessWidget {
  UserDetailsViewModel viewModel;
  UserDetailsEmail({Key? key, 
    required this.viewModel,
  }) : super(key: key);

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
