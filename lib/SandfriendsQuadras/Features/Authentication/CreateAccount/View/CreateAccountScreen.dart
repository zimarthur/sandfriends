import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';

import 'package:provider/provider.dart';
import '../ViewModel/CreateAccountViewModel.dart';
import 'Mobile/CreateAccountWidgetMobile.dart';
import 'Web/CreateAccountWidgetWeb.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final viewModel = CreateAccountCourtViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateAccountCourtViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CreateAccountCourtViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Criar conta",
            childWeb: CreateAccountWidgetWeb(
              viewModel: viewModel,
            ),
            child: CreateAccountWidgetMobile(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
