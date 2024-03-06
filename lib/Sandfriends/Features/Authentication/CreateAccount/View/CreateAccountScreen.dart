import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Model/AppBarType.dart';
import '../../../../../Common/StandardScreen/StandardScreen.dart';
import '../ViewModel/CreateAccountViewModel.dart';
import 'CreateAccountWidget.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final viewModel = CreateAccountViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateAccountViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CreateAccountViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Criar conta",
            appBarType: AppBarType.Secondary,
            child: CreateAccountWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
