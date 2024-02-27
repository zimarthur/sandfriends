import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/DownloadMobile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageFooter.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageHeader.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/ReservationSteps.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/SearchFilter.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

import '../ViewModel/LandingPageViewModel.dart';

class LandingPageWidget extends StatefulWidget {
  const LandingPageWidget({super.key});

  @override
  State<LandingPageWidget> createState() => _LandingPageWidgetState();
}

class _LandingPageWidgetState extends State<LandingPageWidget> {
  bool a = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<LandingPageViewModel>(context, listen: false);
    return Container(
      color: secondaryBackWeb,
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () => setState(() {
                      a = !a;
                    }),
                child: a ? LandingPageHeader() : Container()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ReservationSteps(),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
            SizedBox(
              height: defaultPadding * 4,
            ),
            LandingPageFooter()
          ],
        ),
      ),
    );
  }
}
