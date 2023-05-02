import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/oldApp/theme/app_theme.dart';

class LoadLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.colors.secondaryBack,
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
