import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
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
          return StandardScreen(
            titleText: "Notificações",
            appBarType: AppBarType.Primary,
            child: NotificationsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
