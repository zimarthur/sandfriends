import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Utils/Constants.dart';

class SFLoading extends StatelessWidget {
  const SFLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LoadingAnimationWidget.flickr(
      leftDotColor: primaryBlue,
      rightDotColor: secondaryYellow,
      size: width * 0.1,
    );
  }
}
