import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class DownloadMobile extends StatefulWidget {
  const DownloadMobile({super.key});

  @override
  State<DownloadMobile> createState() => _DownloadMobileState();
}

class _DownloadMobileState extends State<DownloadMobile> {
  double imageHeight = 300;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Image.asset(
              r"assets/background_beach_tennis.png",
              height: imageHeight,
            ),
            Image.asset(
              r"assets/background_futevolei.png",
              height: imageHeight,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: imageHeight,
          color: secondaryYellow.withOpacity(0.4),
        ),
      ],
    );
  }
}
