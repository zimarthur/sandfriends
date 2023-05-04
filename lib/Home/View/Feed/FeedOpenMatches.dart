import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

class FeedOpenMatches extends StatelessWidget {
  HomeViewModel viewModel;
  FeedOpenMatches({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () {
          if (Provider.of<DataProvider>(context, listen: false)
                  .openMatchesCounter >
              0) {
            Navigator.pushNamed(context, '/open_matches_screen');
          }
        },
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.1),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: primaryDarkBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                r"assets\icon\trophy.svg",
                color: textWhite,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
              ),
              Flexible(
                child: Text(
                  Provider.of<DataProvider>(context, listen: false)
                              .openMatchesCounter ==
                          0
                      ? "Não há partidas abertas perto de você"
                      : Provider.of<DataProvider>(context, listen: false)
                                  .openMatchesCounter ==
                              1
                          ? "Existe 1 partida aberta perto de você"
                          : "Existem ${Provider.of<DataProvider>(context, listen: false).openMatchesCounter} partidas abertas perto de você",
                  style: TextStyle(
                    color: textWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
