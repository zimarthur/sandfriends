import 'package:flutter/material.dart';

import '../../../../Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';

class FeedRecurrentMatches extends StatelessWidget {
  final HomeViewModel viewModel;
  const FeedRecurrentMatches({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () => Navigator.pushNamed(context, '/recurrent_matches'),
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
              const Icon(
                Icons.restore,
                color: textWhite,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
              ),
              const Flexible(
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
