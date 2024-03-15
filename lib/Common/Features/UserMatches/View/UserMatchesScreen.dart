import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/UserMatches/View/Web/UserMatchesWidgetWeb.dart';

import '../../../Model/AppBarType.dart';
import '../../../StandardScreen/StandardScreen.dart';
import '../ViewModel/UserMatchesViewModel.dart';
import 'Mobile/UserMatchesWidgetMobile.dart';

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
            child: UserMatchesWidgetMobile(
              viewModel: viewModel,
            ),
            childWeb: UserMatchesWidgetWeb(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
