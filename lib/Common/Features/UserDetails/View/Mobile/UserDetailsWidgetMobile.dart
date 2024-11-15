import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/Constants.dart';
import '../../ViewModel/UserDetailsViewModel.dart';
import '../UserDetailsCard.dart';
import '../UserDetailsEmail.dart';
import '../UserDetailsPhoneNumber.dart';
import '../UserDetailsSportSelector.dart';

class UserDetailsWidgetMobile extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsWidgetMobile({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsWidgetMobile> createState() =>
      _UserDetailsWidgetMobileState();
}

class _UserDetailsWidgetMobileState extends State<UserDetailsWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
              UserDetailsSportSelector(
                viewModel: widget.viewModel,
              ),
              const Padding(padding: EdgeInsets.only(bottom: defaultPadding)),
              SizedBox(
                height: height * 0.6,
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
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      );
    });
  }
}
