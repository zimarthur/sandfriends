import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Common/Utils/Constants.dart';

class PlusButtonOverlay extends StatelessWidget {
  Widget child;
  VoidCallback onTap;
  PlusButtonOverlay({
    required this.child,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (layoutContext, layoutConstraints) {
        double plusButtonHeight = 60;
        return Stack(
          children: [
            child,
            Positioned(
              bottom: defaultPadding / 2,
              left: (layoutConstraints.maxWidth - plusButtonHeight) / 2,
              child: InkWell(
                onTap: () => onTap(),
                child: Container(
                  width: plusButtonHeight,
                  height: plusButtonHeight,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: blueText),
                  child: Center(
                    child: SvgPicture.asset(
                      r"assets/icon/plus.svg",
                      height: 30,
                      color: blueBg,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
