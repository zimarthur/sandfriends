import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/Model/AppBarType.dart';
import '../../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/LoginViewModel.dart';
import 'LoginWidget.dart';

class LoginScreen extends StatefulWidget {
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
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () => viewModel.goToLoginSignup(context),
            onTapBackground: () => viewModel.closeModal(),
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.modalForm,
            pageStatus: viewModel.pageStatus,
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
