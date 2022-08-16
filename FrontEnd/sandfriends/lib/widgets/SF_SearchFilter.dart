import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SFSearchFilter extends StatefulWidget {
  final String labelText;
  final String iconPath;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback onTap;

  const SFSearchFilter({
    required this.labelText,
    required this.iconPath,
    required this.margin,
    required this.padding,
    required this.onTap,
  });

  @override
  State<SFSearchFilter> createState() => _SFSearchFilterState();
}

class _SFSearchFilterState extends State<SFSearchFilter> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            widget.iconPath,
            color: AppTheme.colors.secondaryPaper,
          ),
          Expanded(
            child: Container(
              margin: widget.margin,
              padding: widget.padding,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0, color: AppTheme.colors.secondaryPaper),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      widget.labelText,
                      style: TextStyle(
                        color: AppTheme.colors.textWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    r"assets\icon\arrow_down.svg",
                    color: AppTheme.colors.secondaryPaper,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
