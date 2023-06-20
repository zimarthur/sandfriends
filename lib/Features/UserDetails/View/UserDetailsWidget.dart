import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';
import '../ViewModel/UserDetailsViewModel.dart';
import 'UserDetailsCard.dart';
import 'UserDetailsEmail.dart';
import 'UserDetailsPhoneNumber.dart';
import 'UserDetailsSportSelector.dart';

class UserDetailsWidget extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsWidget({Key? key, 
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsSportSelector(
              viewModel: widget.viewModel,
            ),
            const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            Expanded(
              child: UserDetailsCard(
                viewModel: widget.viewModel,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsPhoneNumber(
              viewModel: widget.viewModel,
            ),
            const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsEmail(
              viewModel: widget.viewModel,
            ),
            const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
          ],
        ),
      );
    });
  }
}
