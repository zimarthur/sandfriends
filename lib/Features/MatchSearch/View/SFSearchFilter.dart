import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/Constants.dart';

class SFSearchFilter extends StatefulWidget {
  final String labelText;
  final String iconPath;
  final VoidCallback onTap;

  const SFSearchFilter({
    Key? key,
    required this.labelText,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.iconPath,
              color: secondaryPaper,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: secondaryPaper,
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
                        style: const TextStyle(
                          color: textWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      r"assets/icon/arrow_down.svg",
                      color: secondaryPaper,
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
