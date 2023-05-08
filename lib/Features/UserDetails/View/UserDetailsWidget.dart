import 'package:flutter/material.dart';
import 'package:sandfriends/Features/UserDetails/View/UserDetailsCard.dart';
import 'package:sandfriends/Features/UserDetails/View/UserDetailsPhoneNumber.dart';
import 'package:sandfriends/Features/UserDetails/View/UserDetailsSportSelector.dart';
import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import 'UserDetailsEmail.dart';

class UserDetailsWidget extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsWidget({
    required this.viewModel,
  });

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
            Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsSportSelector(
              viewModel: widget.viewModel,
            ),
            Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            Expanded(
              child: UserDetailsCard(
                viewModel: widget.viewModel,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsPhoneNumber(
              viewModel: widget.viewModel,
            ),
            Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
            UserDetailsEmail(
              viewModel: widget.viewModel,
            ),
            Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
          ],
        ),
      );
    });
  }
}