import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/widgets/SF_Button.dart';

import '../models/enums.dart';
import '../theme/app_theme.dart';
import '../providers/match_provider.dart';

class SportSelectionScreen extends StatefulWidget {
  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;
    return Container(
      color: AppTheme.colors.primaryBlue,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, top: height * 0.05),
              width: width,
              height: height * 0.2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "O que você quer jogar?",
                  style: TextStyle(
                    color: AppTheme.colors.textWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: SFButton(
                          buttonLabel: "Beach Tennis",
                          buttonType: ButtonType.Secondary,
                          textPadding:
                              EdgeInsets.symmetric(vertical: height * 0.025),
                          onTap: () {
                            Provider.of<MatchProvider>(context, listen: false)
                                .matchSport = Sport.Beachtennis;
                            context.goNamed('match_search_screen');
                          }),
                    ),
                    Container(
                      height: height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: SFButton(
                          buttonLabel: "Futevolei",
                          buttonType: ButtonType.Secondary,
                          textPadding:
                              EdgeInsets.symmetric(vertical: height * 0.025),
                          onTap: () {
                            Provider.of<MatchProvider>(context, listen: false)
                                .matchSport = Sport.futevolei;
                            context.goNamed('match_search_screen');
                          }),
                    ),
                    Container(
                      height: height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: SFButton(
                          buttonLabel: "Vôlei",
                          buttonType: ButtonType.Secondary,
                          textPadding:
                              EdgeInsets.symmetric(vertical: height * 0.025),
                          onTap: () {
                            Provider.of<MatchProvider>(context, listen: false)
                                .matchSport = Sport.volei;
                            context.goNamed('match_search_screen');
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
