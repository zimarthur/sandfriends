import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Authentication/LoginSignup/View/LoginSignupWidget.dart';
import 'package:sandfriends/Authentication/LoginSignup/ViewModel/LoginSignupViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFStandardScreen.dart';

import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SF_Button.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final viewModel = LoginSignupViewModel();

  @override
  void initState() {
    viewModel.initGoogle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginSignupViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<LoginSignupViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            child: LoginSignupWidget(
              viewModel: viewModel,
            ),
            enableToolbar: false,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => false,
            messageModalWidget: viewModel.modalMessage,
          );
        },
      ),
    );
  }
}
