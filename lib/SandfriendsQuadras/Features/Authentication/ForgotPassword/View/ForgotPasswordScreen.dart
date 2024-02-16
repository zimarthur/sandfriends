import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:provider/provider.dart';
import '../ViewModel/ForgotPasswordViewModel.dart';
import 'ForgotPasswordWidget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final viewModel = ForgotPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ForgotPasswordViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<ForgotPasswordViewModel>(
          builder: (context, viewModel, _) {
            return StandardScreen(
              viewModel: viewModel,
              childWeb: ForgotPasswordWidget(
                viewModel: viewModel,
              ),
              child: ForgotPasswordWidget(
                viewModel: viewModel,
              ),
            );
          },
        ),
      ),
    );
  }
}
