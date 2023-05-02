import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Authentication/CreateAccount/View/CreateAccountWidget.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';
import '../ViewModel/CreateAccountViewModel.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final viewModel = CreateAccountViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateAccountViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CreateAccountViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () => viewModel.goToLoginSignup(context),
            onTapBackground: () => viewModel.closeModal(),
            messageModalWidget: viewModel.modalMessage,
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            child: CreateAccountWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
