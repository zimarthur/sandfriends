import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/View/AppInfoWidget.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/ViewModel/AppInfoViewModel.dart';
import 'package:sandfriends/Common/Model/AppBarType.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({
    super.key,
  });

  @override
  State<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  final viewModel = AppInfoViewModel();

  @override
  void initState() {
    viewModel.initAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppInfoViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<AppInfoViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Informações do app",
            appBarType: AppBarType.Primary,
            viewModel: viewModel,
            child: AppInfoWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
