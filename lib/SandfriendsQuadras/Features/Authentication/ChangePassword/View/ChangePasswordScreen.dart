import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:provider/provider.dart';
import '../ViewModel/ChangePasswordViewModel.dart';
import 'ChangePasswordWidget.dart';

class ChangePasswordScreen extends StatefulWidget {
  String token;
  bool isStoreRequest;

  ChangePasswordScreen({
    required this.token,
    required this.isStoreRequest,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final viewModel = ChangePasswordViewModel();

  @override
  void initState() {
    viewModel.init(context, widget.token, widget.isStoreRequest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangePasswordViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            childWeb: ChangePasswordWidget(
              viewModel: viewModel,
            ),
            child: ChangePasswordWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
