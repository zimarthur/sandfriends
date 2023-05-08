import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../oldApp/models/enums.dart';
import '../ViewModel/NotificationsViewModel.dart';
import 'NotificationsWidget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final viewModel = NotificationsViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Primary,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: NotificationsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
