import 'package:flutter/material.dart';
import '../../../oldApp/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SFSearchFilter extends StatefulWidget {
  final String labelText;
  final String iconPath;
  final VoidCallback onTap;

  const SFSearchFilter({
    required this.labelText,
    required this.iconPath,
    required this.onTap,
  });

  @override
  State<SFSearchFilter> createState() => _SFSearchFilterState();
}

class _SFSearchFilterState extends State<SFSearchFilter> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.iconPath,
              color: AppTheme.colors.secondaryPaper,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: AppTheme.colors.secondaryPaper,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.labelText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}