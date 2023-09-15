import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/LoginSignupViewModel.dart';
import 'LoginSignupWidget.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final viewModel = LoginSignupViewModel();

  @override
  void initState() {
    if (!Platform.isIOS){
    viewModel.initGoogle();
    }

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
