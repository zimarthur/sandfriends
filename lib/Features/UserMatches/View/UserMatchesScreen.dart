import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/UserMatchesViewModel.dart';
import 'UserMatchesWidget.dart';

class UserMatchesScreen extends StatefulWidget {
  const UserMatchesScreen({Key? key}) : super(key: key);

  @override
  State<UserMatchesScreen> createState() => _UserMatchesScreenState();
}

class _UserMatchesScreenState extends State<UserMatchesScreen> {
  final viewModel = UserMatchesViewModel();

  @override
  void initState() {
    viewModel.initUserMatchesViewModel(context);
    super.initState();
  }

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
