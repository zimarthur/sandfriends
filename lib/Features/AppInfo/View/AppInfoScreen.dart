import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/AppInfo/View/AppInfoWidget.dart';
import 'package:sandfriends/Features/AppInfo/ViewModel/AppInfoViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/AppBarType.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';

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
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: "Informações do app",
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            onTapReturn: () => viewModel.onTapReturn(context),
            child: AppInfoWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
