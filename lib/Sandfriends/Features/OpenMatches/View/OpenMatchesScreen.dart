import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../ViewModel/OpenMatchesViewModel.dart';
import 'OpenMatchesWidget.dart';

class OpenMatchesScreen extends StatefulWidget {
  const OpenMatchesScreen({Key? key}) : super(key: key);

  @override
  State<OpenMatchesScreen> createState() => _OpenMatchesScreenState();
}

class _OpenMatchesScreenState extends State<OpenMatchesScreen> {
  final viewModel = OpenMatchesViewModel();

  @override
  void initState() {
    viewModel.initOpenMatches(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OpenMatchesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<OpenMatchesViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Partidas abertas",
            appBarType: AppBarType.Primary,
            child: OpenMatchesWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
