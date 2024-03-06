import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
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
          return StandardScreen(
            titleText: "Minhas Partidas",
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
