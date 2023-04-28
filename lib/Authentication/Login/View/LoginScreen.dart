import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/View/SFStandardScreen.dart';
import 'package:sandfriends/Utils/Constants.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../models/enums.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<LoginViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () {
              viewModel.goToLoginSignup(context);
            },
            messageModalWidget: ,
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
