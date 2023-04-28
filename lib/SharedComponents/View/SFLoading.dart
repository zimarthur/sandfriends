import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_theme.dart';

class SFLoading extends StatelessWidget {
  const SFLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LoadingAnimationWidget.flickr(
      leftDotColor: AppTheme.colors.primaryBlue,
      rightDotColor: AppTheme.colors.secondaryYellow,
      size: width * 0.1,
    );
  }
}
