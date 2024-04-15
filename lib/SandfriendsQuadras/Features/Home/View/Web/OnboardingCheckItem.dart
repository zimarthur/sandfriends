import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';

class OnboardingCheckItem extends StatefulWidget {
  String title;
  bool isChecked;
  VoidCallback onTap;

  OnboardingCheckItem({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onTap,
  });

  @override
  State<OnboardingCheckItem> createState() => _OnboardingCheckItemState();
}

class _OnboardingCheckItemState extends State<OnboardingCheckItem> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: SizedBox(
          height: 40,
          width: layoutConstraints.maxWidth,
          child: Row(
            children: [
              SvgPicture.asset(
                r"assets/icon/check_circle.svg",
                color: widget.isChecked
                    ? primaryBlue
                    : isHovered
                        ? textDarkGrey
                        : textLightGrey,
                height: 20,
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Flexible(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.isChecked
                        ? primaryBlue
                        : isHovered
                            ? textDarkGrey
                            : textLightGrey,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
