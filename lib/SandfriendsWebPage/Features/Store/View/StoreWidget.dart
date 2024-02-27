import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Store/ViewModel/StoreViewModel.dart';

import '../../../../Common/Utils/Constants.dart';

class StoreWidget extends StatelessWidget {
  const StoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<StoreViewModel>(context, listen: false);
    return Container(
      color: secondaryBackWeb,
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WebHeader(),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        r"assets/background_beach_tennis.png",
                        height: 400,
                      ),
                      Expanded(
                        child: Container(
                          color: secondaryYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
