import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'sport_selection_screen.dart';

class RecurrentMatchSportSelectionScreen extends StatelessWidget {
  const RecurrentMatchSportSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        context.goNamed('recurrent_match_screen');
        return false;
      },
      child: Scaffold(
        body: Container(
          color: AppTheme.colors.secondaryLightBlue,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('recurrent_match_screen');
                  },
                  child: Container(
                    height: width * 0.1,
                    width: width * 0.1,
                    margin: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.02,
                    ),
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      r'assets\icon\arrow_left.svg',
                      color: AppTheme.colors.secondaryBack,
                    ),
                  ),
                ),
                Expanded(
                  child: SportSelectionScreen(
                    recurrentMatch: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
