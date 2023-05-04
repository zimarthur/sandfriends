import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/UserDetails/View/UserDetailsWidget.dart';
import 'package:sandfriends/UserDetails/ViewModel/UserDetailsViewModel.dart';

import '../../SharedComponents/View/SFStandardScreen.dart';
import '../../oldApp/models/enums.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final viewModel = UserDetailsViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<UserDetailsViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () => viewModel.goToHome(context),
            onTapBackground: () => viewModel.closeModal(),
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.modalForm,
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            child: UserDetailsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
