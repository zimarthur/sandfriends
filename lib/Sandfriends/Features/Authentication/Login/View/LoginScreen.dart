import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Model/AppBarType.dart';
import '../../../../../Common/StandardScreen/StandardScreen.dart';
import '../ViewModel/LoginViewModel.dart';
import 'LoginWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Login",
            appBarType: AppBarType.Secondary,
            child: LoginWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
