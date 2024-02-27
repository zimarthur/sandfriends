import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/DownloadMobile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/LandingPageHeader.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/ReservationSteps.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/SearchFilter.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

class LandingPageWidget extends StatelessWidget {
  const LandingPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: secondaryBackWeb,
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LandingPageHeader(),
            SizedBox(
              height: defaultPadding * 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ReservationSteps(),
            ),
            SizedBox(
              height: defaultPadding * 2,
            ),
          ],
        ),
      ),
    );
  }
}
