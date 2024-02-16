import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

class SFButton extends StatefulWidget {
  final String buttonLabel;
  final Color color;
  final bool isPrimary;
  final VoidCallback? onTap;
  final String iconPath;
  final double iconSize;
  final EdgeInsets? textPadding;
  final bool? iconFirst;

  const SFButton({
    Key? key,
    required this.buttonLabel,
    this.color = primaryBlue,
    this.isPrimary = true,
    required this.onTap,
    this.iconPath = "",
    this.iconSize = 14,
    this.textPadding,
    this.iconFirst = false,
  }) : super(key: key);

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
          color: widget.isPrimary ? widget.color : textWhite,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: widget.color, width: 1),
        ),
        padding: widget.textPadding == null
            ? const EdgeInsets.all(0)
            : widget.textPadding!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.iconPath != "" && widget.iconFirst == false)
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset(
                  widget.iconPath,
                  color: !widget.isPrimary ? widget.color : textWhite,
                ),
              ),
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                widget.buttonLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !widget.isPrimary ? widget.color : textWhite,
                ),
              ),
            ),
            if (widget.iconPath != "" && widget.iconFirst == true)
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  widget.iconPath,
                  color: !widget.isPrimary ? widget.color : textWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
