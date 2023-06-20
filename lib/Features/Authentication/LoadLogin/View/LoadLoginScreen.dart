import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Utils/Constants.dart';
import '../ViewModel/LoadLoginViewModel.dart';

class LoadLoginScreen extends StatefulWidget {
  String? externalLink;
  LoadLoginScreen({Key? key, 
    this.externalLink,
  }) : super(key: key);

  @override
  State<LoadLoginScreen> createState() => _LoadLoginScreenState();
}

class _LoadLoginScreenState extends State<LoadLoginScreen> {
  final viewModel = LoadLoginViewModel();

  @override
  void initState() {
    if (widget.externalLink == null) {
      viewModel.validateLogin(context);
    } else {
      viewModel.redirectExternalLogin();
    }
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
                r'assets\icon\sand_bar.svg',
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Center(
                child: Image.asset(
              r'assets\icon\logo.png',
              alignment: Alignment.center,
              height: 120,
            )),
          ],
        ),
      ),
    );
  }
}
