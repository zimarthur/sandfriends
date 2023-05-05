import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

class FeedRecurrentMatches extends StatelessWidget {
  HomeViewModel viewModel;
  FeedRecurrentMatches({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () => Navigator.pushNamed(context, '/recurrent_match_screen'),
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.1),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: primaryLightBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.restore,
                color: textWhite,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
              ),
              Flexible(
                child: Text(
                  "Área do Mensalista",
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
