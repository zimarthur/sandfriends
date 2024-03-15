import 'package:flutter/material.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import 'package:provider/provider.dart';
import '../ViewModel/LoginViewModel.dart';
import 'LoginWidgetMobile.dart';
import 'LoginWidgetWeb.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.validateToken(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<LoginViewModel>(
          builder: (context, viewModel, _) {
            return StandardScreen(
              enableToolbar: false,
              childWeb: LoginWidgetWeb(
                viewModel: viewModel,
              ),
              child: LoginWidgetMobile(
                viewModel: viewModel,
              ),
            );
          },
        ),
      ),
    );
  }
}
