import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';

import '../../../../../Common/Utils/Constants.dart';
import '../ViewModel/LoadLoginViewModel.dart';

class LoadLoginScreen extends StatefulWidget {
  final String? redirectUri;
  const LoadLoginScreen({
    Key? key,
    this.redirectUri,
  }) : super(key: key);

  @override
  State<LoadLoginScreen> createState() => _LoadLoginScreenState();
}

class _LoadLoginScreenState extends State<LoadLoginScreen> {
  final viewModel = LoadLoginViewModel();

  @override
  void initState() {
    Provider.of<EnvironmentProvider>(context, listen: false)
        .initEnvironmentProvider(context)
        .then((value) {
      if (widget.redirectUri != null) {
        viewModel.storeRedirectUri(context, widget.redirectUri!);
      }
      viewModel.validateLogin(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: secondaryBack,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                r'assets/icon/sand_bar.svg',
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Center(
                child: Image.asset(
              r'assets/icon/logo.png',
              alignment: Alignment.center,
              height: 120,
            )),
          ],
        ),
      ),
    );
  }
}
