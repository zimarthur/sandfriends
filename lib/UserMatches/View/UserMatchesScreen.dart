import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/UserMatches/View/UserMatchesWidget.dart';
import 'package:sandfriends/UserMatches/ViewModel/UserMatchesViewModel.dart';

import '../../SharedComponents/View/SFStandardScreen.dart';
import '../../oldApp/models/enums.dart';

class UserMatchesScreen extends StatefulWidget {
  const UserMatchesScreen({Key? key}) : super(key: key);

  @override
  State<UserMatchesScreen> createState() => _UserMatchesScreenState();
}

class _UserMatchesScreenState extends State<UserMatchesScreen> {
  final viewModel = UserMatchesViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMatchesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<UserMatchesViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () => viewModel.goToHome(context),
            onTapBackground: () => viewModel.closeModal(),
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.modalForm,
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            child: UserMatchesWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}