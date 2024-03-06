import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Authentication/EmailConfirmation/ViewModel/EmailConfirmationViewModel.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';

import '../../../../../Common/Utils/Constants.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String confirmationToken;
  const EmailConfirmationScreen({
    super.key,
    required this.confirmationToken,
  });

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final viewModel = EmailConfirmationViewModel();

  @override
  void initState() {
    viewModel.confirmEmail(context, widget.confirmationToken);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmailConfirmationViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<EmailConfirmationViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            enableToolbar: false,
            child: Container(
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
        },
      ),
    );
  }
}
