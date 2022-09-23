import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

enum ButtonType { Primary, Secondary, Disabled }

class SFButton extends StatefulWidget {
  final String buttonLabel;
  final ButtonType buttonType;
  final VoidCallback? onTap;
  final double fontSize;
  final String iconPath;
  final double iconSize;
  final EdgeInsets? textPadding;

  const SFButton(
      {required this.buttonLabel,
      required this.buttonType,
      required this.onTap,
      this.fontSize = 14,
      this.iconPath = "",
      this.iconSize = 14,
      this.textPadding});

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
              : widget.buttonType == ButtonType.Secondary
                  ? AppTheme.colors.secondaryPaper
                  : AppTheme.colors.textDisabled,
          borderRadius: BorderRadius.circular(16.0),
          border: widget.buttonType == ButtonType.Secondary
              ? Border.all(color: AppTheme.colors.primaryBlue, width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        : AppTheme.colors.textWhite,
                  ),
                ),
              ),
            ),
            widget.iconPath == ""
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      widget.iconPath,
                      height: widget.iconSize,
                      color: widget.buttonType == ButtonType.Secondary
                          ? AppTheme.colors.primaryBlue
                          : AppTheme.colors.textWhite,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
