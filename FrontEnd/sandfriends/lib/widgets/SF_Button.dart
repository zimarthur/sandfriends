import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

enum ButtonType {
  Primary,
  Secondary,
  Disabled,
  YellowPrimary,
  YellowSecondary,
  LightBlue
}

class SFButton extends StatefulWidget {
  final String buttonLabel;
  final ButtonType buttonType;
  final VoidCallback? onTap;
  final String iconPath;
  final double iconSize;
  final EdgeInsets? textPadding;
  final bool? iconFirst;

  const SFButton({
    required this.buttonLabel,
    required this.buttonType,
    required this.onTap,
    this.iconPath = "",
    this.iconSize = 14,
    this.textPadding,
    this.iconFirst = false,
  });

  @override
  State<SFButton> createState() => _SFButtonState();
}

class _SFButtonState extends State<SFButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.buttonType == ButtonType.Primary
              ? AppTheme.colors.primaryBlue
              : widget.buttonType == ButtonType.YellowPrimary
                  ? AppTheme.colors.secondaryYellow
                  : widget.buttonType == ButtonType.LightBlue
                      ? AppTheme.colors.primaryLightBlue
                      : widget.buttonType == ButtonType.Secondary ||
                              widget.buttonType == ButtonType.YellowSecondary
                          ? AppTheme.colors.secondaryPaper
                          : AppTheme.colors.textDisabled,
          borderRadius: BorderRadius.circular(16.0),
          border: widget.buttonType == ButtonType.Secondary
              ? Border.all(color: AppTheme.colors.primaryBlue, width: 1)
              : widget.buttonType == ButtonType.YellowSecondary
                  ? Border.all(color: AppTheme.colors.secondaryYellow, width: 1)
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.iconPath == "" || widget.iconFirst == false
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      widget.iconPath,
                      color: widget.buttonType == ButtonType.Secondary
                          ? AppTheme.colors.primaryBlue
                          : widget.buttonType == ButtonType.YellowSecondary
                              ? AppTheme.colors.secondaryYellow
                              : AppTheme.colors.textWhite,
                    ),
                  ),
            Padding(
              padding: widget.textPadding == null
                  ? const EdgeInsets.all(0)
                  : widget.textPadding!,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  widget.buttonLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.buttonType == ButtonType.Secondary
                        ? AppTheme.colors.primaryBlue
                        : widget.buttonType == ButtonType.YellowSecondary
                            ? AppTheme.colors.secondaryYellow
                            : AppTheme.colors.textWhite,
                  ),
                ),
              ),
            ),
            widget.iconPath == "" || widget.iconFirst == true
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      widget.iconPath,
                      color: widget.buttonType == ButtonType.Secondary
                          ? AppTheme.colors.primaryBlue
                          : widget.buttonType == ButtonType.YellowSecondary
                              ? AppTheme.colors.secondaryYellow
                              : AppTheme.colors.textWhite,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
