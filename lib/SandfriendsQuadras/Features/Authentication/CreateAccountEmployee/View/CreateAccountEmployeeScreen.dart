import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:provider/provider.dart';
import '../ViewModel/CreateAccountEmployeeViewModel.dart';
import 'CreateAccountEmployeeWidget.dart';

class CreateAccountEmployeeScreen extends StatefulWidget {
  String token;
  CreateAccountEmployeeScreen({
    required this.token,
  });

  @override
  State<CreateAccountEmployeeScreen> createState() =>
      _CreateAccountEmployeeScreenState();
}

class _CreateAccountEmployeeScreenState
    extends State<CreateAccountEmployeeScreen> {
  final viewModel = CreateAccountEmployeeViewModel();

  @override
  void initState() {
    viewModel.initCreateAccountEmployeeViewModel(context, widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateAccountEmployeeViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CreateAccountEmployeeViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            childWeb: CreateAccountEmployeeWidget(
              viewModel: viewModel,
            ),
            child: CreateAccountEmployeeWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
